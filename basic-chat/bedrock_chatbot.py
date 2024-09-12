import boto3
import json
import streamlit as st
import yaml

# Load configuration
def load_config(config_file='config.yml'):
    with open(config_file, 'r') as file:
        return yaml.safe_load(file)

config = load_config()

# Initialize the Bedrock client
bedrock = boto3.client('bedrock-runtime')#service_name='bedrock-runtime')
# ,
#     region_name=config['aws']['region_name']
# )

def get_bedrock_response(prompt):
    # Ensure the prompt starts with "Human: " and ends with "\n\nHuman: "
    formatted_prompt = f"Human: {prompt}\n\nHuman: "

    # Format the messages for Claude 3
    messages = [
        {
            "role": "user",
            "content": prompt
        }
    ]

    body = json.dumps({
        "anthropic_version": "bedrock-2023-05-31",
        "messages": messages,
        "max_tokens": config['bedrock']['max_tokens_to_sample'],
        "temperature": config['bedrock']['temperature'],
        "top_p": config['bedrock']['top_p']
    })

    response = bedrock.invoke_model(
        modelId=config['bedrock']['model_id'],
        contentType='application/json',
        accept='application/json',
        body=body
    )

    #response_body = json.loads(response['body'].read())
    #return response_body['completion']
    response_body = json.loads(response['body'].read())
    
    # Extract the assistant's response
    assistant_response = response_body['content'][0]['text']
    
    return assistant_response

# Streamlit UI
st.title(config['app']['title'])

# Initialize chat history
if 'messages' not in st.session_state:
    st.session_state.messages = []

# Display chat messages from history on app rerun
for message in st.session_state.messages:
    with st.chat_message(message["role"]):
        st.markdown(message["content"])

# React to user input
if prompt := st.chat_input("What is your question?"):
    # Display user message in chat message container
    st.chat_message("user").markdown(prompt)
    # Add user message to chat history
    st.session_state.messages.append({"role": "user", "content": prompt})

    # Generate response from Bedrock
    response = get_bedrock_response(prompt)
    
    # Display assistant response in chat message container
    with st.chat_message("assistant"):
        st.markdown(response)
    # Add assistant response to chat history
    st.session_state.messages.append({"role": "assistant", "content": response})
