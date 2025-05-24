from flask import Flask, request, send_from_directory
from openai import OpenAI
import random
import os

app = Flask(__name__)

# Set your OpenAI API key in environment variable
openai_client = OpenAI(api_key=os.getenv("OPENAI_API_KEY"))

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

        return content
   
    return '''
        <form method="post">
            Create a site about: <input name="prompt">
            <input type="submit" value="Generate Site">
        </form>
    '''

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8080)
