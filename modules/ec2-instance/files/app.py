from flask import Flask, request, send_from_directory
from openai import OpenAI
import random
import hashlib
import os
import logging

app = Flask(__name__)
app.logger.setLevel(logging.DEBUG)

GENERATED_SITE_DIR = os.path.join("static", "sites")
os.makedirs(GENERATED_SITE_DIR, exist_ok=True)

# Set your OpenAI API key in environment variable
openai_client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

# In-memory short URL store
url_store = {}

@app.route('/', methods=['GET', 'POST'])
def make_site():
    if request.method == 'POST':
        prompt = request.form['prompt']

        response = openai_client.chat.completions.create(
            model="gpt-4o",
            messages=[
                    {"role": "system", "content": "You are a web designer who only writes full standalone HTML files with embedded CSS. Use original and creative design. You can make it retro, funny or 90s style or another ranndom style. Print only the website not anything else. You don't write comments about anything just the code. Don't use ``` either. Response is to be used as a html file. When fetching images for the HTML use real ones and not placeholders. try to find the most recent image links as possbile in order to avoid dead links. prefer sources are designed for public re-use and are less likely to go offline. Always confirm if the images are valid."},
                    {"role": "user", "content": f"{prompt}"}
                ],
            temperature=1.1,
            max_tokens=8000
        )
  
        content = response.choices[0].message.content

        # Save to a file
        filename = f"{abs(hash(prompt)) % (10 ** 8)}.html"
        filepath = os.path.join(GENERATED_SITE_DIR, filename)
        #with open(filepath, "w", encoding="utf-8") as f:
        #    f.write(content)

        # Return link to view it
        #return f'Your AI site is ready: <a href="/site/{filename}">/site/{filename}</a>'
        return content
   
    return '''
        <form method="post">
            Create a site about: <input name="prompt">
            <input type="submit" value="Generate Site">
        </form>
    '''

#@app.route('/site/<filename>')
#def serve_site(filename):
#    return send_from_directory(GENERATED_SITE_DIR, filename)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080, debug=True)
