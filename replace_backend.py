import re

with open('d:/TA/Tilawati/backend/app/services/ai_service.py', 'r', encoding='utf-8') as f:
    content = f.read()

with open('d:/TA/Tilawati/backend/temp_jilid_backend.txt', 'r', encoding='utf-8') as f:
    backend_text = f.read().strip()

# Replace the jilid 1 block
new_content = re.sub(
    r'1: \{\s*"title": "Jilid 1.*?\},\n    2: \{',
    f'{backend_text}\n    2: {{',
    content,
    flags=re.DOTALL
)

with open('d:/TA/Tilawati/backend/app/services/ai_service.py', 'w', encoding='utf-8') as f:
    f.write(new_content)
