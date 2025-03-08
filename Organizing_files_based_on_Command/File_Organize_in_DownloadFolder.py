import os
import shutil

source_folder = "./Downloads"
destination_folders = {
    "Images": [".jpg", ".png", ".gif"],
    "Documents": [".pdf", ".docx", ".txt",".xlsx",".pptx",".csv"],
    "Videos": [".mp4", ".mov", ".avi"],
}

skipped_files = []  # List to collect skipped files

total_files = len(os.listdir(source_folder))
for index, file in enumerate(os.listdir(source_folder)):
    file_path = os.path.join(source_folder, file)
    if os.path.isfile(file_path):
        for folder, extensions in destination_folders.items():
            if any(file.endswith(ext) for ext in extensions):
                os.makedirs(os.path.join(source_folder, folder), exist_ok=True)
                destination_path = os.path.join(source_folder, folder, file)
                if os.path.exists(destination_path):
                    skipped_files.append(file)  # Collect skipped file
                    print(f"File {file} already exists in {folder}. Skipping.")
                    
                    #remove 
                    ## os.remove(file_path)
                    continue
                shutil.move(file_path, os.path.join(source_folder, folder))
    print(f"Progress: {index + 1}/{total_files} files processed.")


    # Display skipped files at the end
if skipped_files:
    print("\nSkipped files:")
    for skipped in skipped_files:
        print(skipped)
else:
    print("\nNo files were skipped.")