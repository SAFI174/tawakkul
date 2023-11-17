import requests
import json

# Define the base URL and the total number of pages (604 in this case)
base_url = "https://api.quran.com/api/v4/verses/by_page/"
total_pages = 604

# Function to remove specified keys recursively from a dictionary
def remove_keys_recursive(dictionary, keys_to_remove):
    for key in list(dictionary.keys()):
        if key in keys_to_remove:
            del dictionary[key]
        elif isinstance(dictionary[key], dict):
            remove_keys_recursive(dictionary[key], keys_to_remove)
        elif isinstance(dictionary[key], list):
            for item in dictionary[key]:
                if isinstance(item, dict):
                    remove_keys_recursive(item, keys_to_remove)

# Loop through pages and save each page's data in a separate JSON file
for page_number in range(1, total_pages + 1):
    url = f"{base_url}{page_number}?words=true&word_fields=v1_page,text_uthmani,text_indopak,codeV1&fields=text_uthmani_simple,text_uthmani"

    # Send a GET request to the API
    response = requests.get(url)

    # Check if the request was successful
    if response.status_code == 200:
        data = response.json()

        # Remove the "pagination" section if it exists
        if "pagination" in data:
            del data["pagination"]

        # Remove "audio_url" and "transliteration" fields from "words" section
        remove_keys_recursive(data, ["audio_url", "transliteration"])

        verses_data = data

        # Define the JSON file name
        json_file_name = f"page_{page_number}.json"

        # Optionally, save the "verses" data to a separate JSON file
        verses_file_name = f"page_{page_number}.json"
        with open(verses_file_name, 'w', encoding='utf-8') as verses_file:
            json.dump(verses_data, verses_file, ensure_ascii=False, indent=4)

        print(f"Verses data from page {page_number} saved as {verses_file_name}")
    else:
        print(f"Failed to retrieve data for page {page_number}")

print("Data retrieval and saving completed.")
