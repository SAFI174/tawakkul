import sqlite3
import json
import os

# Directory where the JSON files are located
directory_path = "jsons\\"

# Database connection
db_path = "quran.db"
connection = sqlite3.connect(db_path)
cursor = connection.cursor()

def create_verse_table():
    cursor.execute('''CREATE TABLE IF NOT EXISTS verses 
                   (id INTEGER PRIMARY KEY, 
                   verse_number INTEGER, 
                   verse_key TEXT, 
                   hizb_number INTEGER,
                   rub_el_hizb_number INTEGER,
                   text_uthmani_simple TEXT,
                   page_number INTEGER,
                   juz_number INTEGER)''')
    connection.commit()

# Function to create a new table if it doesn't exist
def create_words_table():
    cursor.execute('''
        CREATE TABLE IF NOT EXISTS words (
            id INTEGER PRIMARY KEY,
            verse_id INTEGER,
            position INTEGER,
            char_type_name TEXT,
            v2_page INTEGER,
            text_uthmani TEXT,
            code_v2 TEXT,
            page_number INTEGER,
            line_number INTEGER,
            text TEXT,
            translation_text TEXT,
            translation_language_name TEXT
        )
    ''')
    connection.commit()

# Function to read JSON file
def read_json_file(file_path):
    with open(file_path, 'r', encoding='utf-8') as file:
        data = json.load(file)
    return data

def insert_verse_data(verse_data):
    query = '''INSERT INTO verses (id,
    verse_number,
    verse_key,
    hizb_number,
    rub_el_hizb_number,
    text_uthmani_simple,
    page_number,
    juz_number) VALUES (?, ?, ?, ?, ?, ?, ?, ?)'''
    cursor.execute(query, (
        verse_data['id'],
        verse_data['verse_number'],
        verse_data['verse_key'],
        verse_data['hizb_number'],
        verse_data['rub_el_hizb_number'],
        verse_data['text_uthmani_simple'],
        verse_data['page_number'],
        verse_data['juz_number']
    ))
    connection.commit()

# Function to insert word data into the words table
def insert_word_data(word_data, verse_id):
    query = '''
        INSERT INTO words (
            verse_id,
            position,
            char_type_name,
            v2_page,
            text_uthmani,
            code_v2,
            page_number,
            line_number,
            text,
            translation_text,
            translation_language_name
        ) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
    '''
    cursor.execute(query, (
        verse_id,
        word_data['position'],
        word_data['char_type_name'],
        word_data['v2_page'],
        word_data['text_uthmani'],
        word_data['code_v2'],
        word_data['page_number'],
        word_data['line_number'],
        word_data['text'],
        word_data['translation']['text'],
        word_data['translation']['language_name']
    ))
    connection.commit()

# Function to process all files
def process_all_files(directory):
    create_verse_table()
    create_words_table()
    for filename in os.listdir(directory):
        if filename.endswith(".json"):
            file_path = os.path.join(directory, filename)
            print(f"Processing file: {file_path}")
            data = read_json_file(file_path)

            for verse_data in data['verses']:
                insert_verse_data(verse_data)
                verse_id = verse_data['id']

                for word_data in verse_data['words']:
                    insert_word_data(word_data, verse_id)

if __name__ == "__main__":
    process_all_files(directory_path)

# Close the database connection
connection.close()
