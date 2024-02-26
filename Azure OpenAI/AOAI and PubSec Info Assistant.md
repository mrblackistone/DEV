<!-- TOC -->

- [Purpose](#purpose)
- [Lexicon](#lexicon)
  - [Solutions](#solutions)
  - [Models](#models)
  - [Mathematics](#mathematics)
- [Chunking, Tokenization, and Embedding](#chunking-tokenization-and-embedding)
  - [Queries and Responses](#queries-and-responses)
  - [Search Resources](#search-resources)
- [PubSec Info Assistant](#pubsec-info-assistant)
  - [Pre-requisites](#pre-requisites)
  - [Instructions](#instructions)
  - [Troubleshooting](#troubleshooting)
- [Usage and Demo](#usage-and-demo)
  - [Ingesting Data](#ingesting-data)
  - [UI Title and Banner](#ui-title-and-banner)
  - [Changing the PubSec Info Assistant's Behavior](#changing-the-pubsec-info-assistants-behavior)
    - [Chat Settings](#chat-settings)
    - [System Message](#system-message)
  - [Thought Process](#thought-process)
  - [Prompt Engineering](#prompt-engineering)
  - [Saving Money](#saving-money)
- [Infrastructure](#infrastructure)
- [Appendix](#appendix)

<!-- /TOC -->


# Purpose

The purpose of this document is to consolidate information relating to OpenAI generally, Azure OpenAI specifically, generative AI concepts, and use of the PubSec Info Assistant offering from Microsoft to learn how to deploy, configure, and use generative AI in a production environment.

# Lexicon

In order to get the most out of this document, it is best to learn the terminology that is used. Some words will be new, while others may have different meanings (in the context of generative AI) than you are used to.

## Solutions

- **Information Assistant Accelerator** - Another name for the PubSec Info Assistant, a proof-of-concept made publicly available on GitHub for educational purposes and targeted at Public Sector application teams. The Information Assistant Accelerator is meant to demonstrate how a complete generative-AI system should be architected, how it can be deployed, and concepts relating to user interactions with it such as the effect of changing "Top-P", "Temperature", and the "System Message".


## Models

- **Machine Learning Model** - A machine learning model can be used to recognize patterns or make predictions based on data. A machine learning model is created by training a machine learning algorithm with data. This training process means that the original data is not explicitly stored or contained within the model itself, but rather influences the strength of connections generated within the model. Machine learning models are useful for many applications, such as image recognition, natural language processing, recommendation systems, and more.
- **Generative Model** - A <a href="https://openai.com/research/generative-models">generative model</a> is a type of machine learning model that aims to learn the underlying patterns or distributions of data in order to generate new, similar data. Text generation models include GPT 3.5 and 4.
- **Parameter** - Parameters are adjustable elements in a model that are learned from training data. These include weights in neural networks and settings in machine learning algorithms. Parameters influence the behavior of AI models and determine how they make predictions or decisions. The total number of parameters in a model is influenced by various factors such as the model's structure, the number of layers of neurons, and the complexity of the model.
   - ChatGPT 3.5 is made up of 175 Billion parameters.
   - ChatGPT 4 is far larger, at over 100 Trillion parameters.
- **Checkpoint** - A checkpoint is a snapshot of a trained model's parameters (weights and biases) at a specific point during training.

## Mathematics

- **Vector** - A vector is a quantity that has a magnitude and direction. In OpenAI, a vector is represented as an array (list) of floating point numbers. The length of the array corresponds to the vector dimension. For instance, the vector [3.0,4.0] corresponds to a 2-vector having magnitude 5 (3: 4 :5 is a pythagorean triple, as 3<sup>2</sup> + 4<sup>2</sup> = 5<sup>2</sup>). Therefore, the number of dimensions of the array, n, corresponds to the length of the array (i.e., an *n-array*)
- **Dimensions** - The ada 2 embedding model has only 1,536 dimensions, which is impossible for a person to visualize.
- **Vector database** - A <a href="https://learn.microsoft.com/en-us/azure/cosmos-db/vector-database">vector database</a> is a database designed to store and manage vector embeddings, which are mathematical representations of data in a high-dimensional space. In this space, each dimension corresponds to a feature of the data, and tens of thousands of dimensions might be used to represent sophisticated data. A vector's position in this space represents its characteristics. Words, phrases, or entire documents, and images, audio, and other types of data can all be vectorized. These vector embeddings are used in similarity search, multi-modal search, recommendations engines, large languages models (LLMs), etc.
- **Cosine similarity** - Azure OpenAI embeddings rely on <a href="https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/understand-embeddings">cosine similarity</a> to compute similarity between documents and a query. From a mathematic perspective, cosine similarity measures the cosine of the angle between two vectors projected in a multidimensional space. This measurement is beneficial, because if two documents are far apart by Euclidean distance due to size, they could still have a smaller angle between them and therefore higher cosine similarity.
   - Note that OpenAI embeddings are <a href="https://platform.openai.com/docs/guides/embeddings/frequently-asked-questions">normalized to length 1</a>, which means that cosine similarity can be computed a bit faster using only a dot product, and that cosine similarity and Euclidean distance will result in identical rankings. (Dot product is the sum of the products of multiplying each element in equal-length arrays, for instance: a<sub>1</sub>b<sub>1</sub> + a<sub>2</sub>b<sub>2</sub> + ... a<sub>n</sub>b<sub>n</sub>)


# Chunking, Tokenization, and Embedding

- **Token** - A <a href=https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them>token</a> is a single piece of text from an input that is associated (embedded) as a particular value in a vector. Tokens can include words with specific capitalization, sub-words, or punctuation. For instance, the sentence "Jake likes to eat, especially cake." might be broken out into the following tokens:
   - A word not preceded by a space, starting with a capital letter: "**Jake**"
   - A word preceded by a space, starting with a lower-case letter: " **likes**"
   - A word preceded by a space, starting with a lower-case letter: " **to**"
   - A word preceded by a space, starting with a lower-case letter: " **eat**"
   - A comma:  "**,**"
   - A word preceded by a space, starting with a lower-case letter: " **especially**"
   - A word preceded by a space, starting with a lower-case letter: " **cake**"
   - A period: "**.**"
   - You can see how text is tokenized by OpenAI using <a href="https://platform.openai.com/tokenizer">this tool</a>.
   - For English, a good rule-of-thumb is that there are 0.75 words per token. Other languages will typically require a greater number of tokens.
- **Embedding** - An <a href="https://platform.openai.com/docs/guides/embeddings">embedding</a> is a special format of data representation that can be easily utilized by machine learning models and algorithms. The embedding is an information-dense representation of the semantic meaning of a piece of text. Each embedding is a vector of floating point numbers, such that the distance between two embeddings in the vector space is correlated with semantic similarity between two inputs in the original format. Depending on the system, each Token may be assigned a specific number in the vector. There are also limits associated with tokenization models, for instance <a href="https://openai.com/blog/new-and-improved-embedding-model">Ada 2</a> supports up to 8191 tokens at a time, and ChatGPT has a token limit shared between prompt and completion that varies with model and version.
   - Example:  Using the previous example for Tokenization, the tokens might be embedded thusly:
   - The Tokens before embedding: ["**Jake**", " **likes**", " **to**", " **eat**", "**,**", " **especially**", " **cake**", "**.**"]
   - After embedding: [**7.438294**, **-0.782139**, **1.728197**, **-4.278129**, **-1.743892**, **6.273129**, **2.237180**, **9.728193**]
   - Note:  This is purely a generic example to present a concept. These are not necessarily the values that would be generated in an actual OpenAI or similar system. For instance, Ada-2 has a fixed output dimension of 1,536 rather than the eight presented here.
   - You can learn more about embeddings at <a href="https://learn.microsoft.com/en-us/azure/ai-services/openai/tutorials/embeddings?tabs=python%2Ccommand-line&pivots=programming-language-python">this link</a>.
- **Chunk/chunking** - Due to token limits, the documents that the PubSec Info Assistant ingests are <a href="https://learn.microsoft.com/en-us/azure/search/vector-search-how-to-chunk-documents">chunked</a> (broken up) and pre-processed into a format that's easier to use, especially complex file types like PDF. The PDF files are processed through Azure AI Document Intelligence, whereas other file types are processed through Unstructured.io, both of which result in JSON-based representations. Pre-processing status is logged in Cosmos DB. Chunking can also include overlap, to ensure that data is not split across chunks when it shouldn't be. Note that OpenAI typically performs better when documents are chunked by section rather than by page, paragraph, or fixed sizes.
   - Other options to chunk documents include <a href="https://python.langchain.com/en/latest/index.html">LangChain</a> and <a href="https://github.com/microsoft/semantic-kernel">Semantic Kernel</a>.


## Queries and Responses

- **Retrieval Augmented Generation (RAG)** - Retrieval Augmentation Generation (RAG) is an architecture that augments the capabilities of a Large Language Model (LLM) like ChatGPT by adding an information retrieval system that provides grounding data. It utilizes Azure AI Search's Vector Hybrid Search capabilities to retrieve documents that are contextually relevant for precise answers. This approach empowers you to find relevant information efficiently by combining the strengths of both semantic vectors and keywords. As such, you don't have to go through the immense time and expense of training your own model.
- **Persona** - The "tone" and language used by the AI, such as "an Assistant" or "a Teacher". Depending on the model used, this can impact how it presents responses to varying degrees.
- **Chain of Thought** - Chain of Thought refers to the absence of persistent "memory" in the OpenAI instance as to your previous queries, resulting in the need with each new query in a session to include all previous questions and answers.  This allows OpenAI to provide contextually-appropriate responses based on the conversation so far, without having to store your previous queries or its responses.
- **Session** - A session is a single Chain of Thought, meaning when all previous requests and responses are included with each new request, and impact how the AI responds. To eliminate the effect of previous interactions on future responses, you must start a new session, which resets the Chain of Thought.  This is particularly important when shifting focus to a new subject that has little or nothing to do with the queries you've made so far.
- **Grounding** - Grounding refers to the act of limiting results to a specific dataset, rather than the LLM in its entirety.  For instance, if you provide organizational policy documents, grounding means that the PubSec Info Assistant will be limited to providing responses which are relevant to those policy documents.
- **System Message/Metaprompt** - A system message is an optional (but highly recommended) initial message sent automatically in every new session, typically hidden from the user, that tells the system how responses should be constructed, what kind of persona the system and user should have, etc.
- **One-shot** - One-shot is when a single example interaction is provided in the system message.
- **Few-shot** - Few-shot is when more than one example interaction is provided in the system message, though it should consist of three or more examples, because providing only two appears to afford no benefit over just a single shot.
- **Zero-shot** - Zero-shot is when no example interactions are proided in the system message.
- **Enrichment Pipeline** - This term refers to the process of ingesting, parsing, and chunking input data to provide the embedding vectors that will be used by the PubSec Info Assistant to provide relevant responses to queries.

## Search Resources

- **Azure AI Search** - This accelerator employs Vector Hybrid Search, which combines vector similarity with keyword matching to enhance search accuracy. (Note that in Azure Government keyword search is not yet available as of Feb 21, 2024.) This approach empowers you to find relevant information efficiently by combining the strengths of both semantic vectors and keywords.
- **Types of Search Methods** - Different search methods. For the Information Assistant Accelerator, only Vector search is currently available (Feb 21, 2024).
   - **Vector** - <a href="https://learn.microsoft.com/en-us/azure/search/vector-search-overview">Vector search</a> is an approach in information retrieval that stores numeric representations of content for search scenarios. Because the content is numeric rather than plain text, the search engine matches on vectors that are the most similar to the query, with no requirement for matching on exact terms.
   - **Hybrid** - Hybrid search is a combination of full text and vector queries that execute against a search index that contains both searchable plain text content and generated embeddings. For query purposes, hybrid search is:
      - A single query request that includes both search and vectors query parameters
      - Executing in parallel
      - With merged results in the query response, scored using Reciprocal Rank Fusion (RRF)
   - **Full Text** - A full-text search is a comprehensive method that compares every word of the search request against every word within a document or database.
   - **Keyword** - Keyword search looks for exact matches of words, but lacks semantic understanding.
   - **Semantic Ranker** (proprietary in Azure AI Search) - In Azure AI Search, semantic ranking measurably improves search relevance by using language understanding to rerank search results. Semantic ranking doesn't use generative AI or vectors. Semantic ranker is a collection of query-related capabilities that improve the quality of an initial BM25-ranked or RRF-ranked search result for text-based queries. When you enable it on your search service, semantic ranking extends the query execution pipeline in two ways:
      - First, it adds secondary ranking over an initial result set that was scored using BM25 or RRF. This secondary ranking uses multi-lingual, deep learning models adapted from Microsoft Bing to promote the most semantically relevant results.
      - Second, it extracts and returns captions and answers in the response, which you can render on a search page to improve the user's search experience.

# PubSec Info Assistant

The PubSec Info Assistant is a ready-to-use teaching tool which deploys a functional Azure OpenAI application into a target Azure environment, designed with application teams in mind so they can learn how to deploy, modify, and use an Azure OpenAI ChatGPT application that uses grounding data to provide answers specific to the organization.

All up-to-date official documentation is located in the repository. This section consolidates information from that documentation, but is only a point-in-time collection, and should not be regarded as the official source of information.

NOTE:  The instructions are written for all three of the following scenarios. Confirm which scenario is applicable to you before starting, and keep it in mind as you progress through the steps:
- Azure OpenAI (AOAI) instance will reside in the same resource group as the other resources.
- AOAI instance will reside in a different resource group as the other resources.
- AOAI instance will reside in a different tenant or cloud than the other resources.


## Pre-requisites

1. An **Azure Tenant** where you have permissions to:
   - **Create service principals** (applications).
2. An **Azure subscription** in that same tenant where you have rights to:
   - **Change permissions**
   - **Deploy resources**
   - **Delete deployments**
   - **Create resource groups**
3. An **Azure Tenant** (the same one or a different one) **and Subscription** where you have permissions to:
   - **Deploy and read an Azure OpenAI instance**, **or**
   - One is already deployed and you have access to **read its name, key, and can get into the OpenAI studio to set up model deployments**.
4. A **Github account**.
5. Optional, but strongly recommended:  **VS Code w/ GitHub Workspaces extension** loaded on your local system.

## Instructions

1. In the Azure tenant where the Azure OpenAI instance resides, or will reside:
   - **Create** an Azure **OpenAI instance**, if you haven't already.
   - **Open** the OpenAI instance and on the **Overview** blade select the button to open **Azure OpenAI Studio**.
   - In OpenAI Studio, go to **Management > Deployments**.
   - **Create two deployments**:
      - One "**gpt**" text generation model.
      - One "**ada**" text embedding model.
   - Take note of the **model name**, **model version**, and **deployment name** you give each of them. All three pieces of information for both of the deployments will be used later.
2. In the Azure Subscription where you will be deploying the rest of your PubSec Info Assistant resources:
   - Create an **Azure AI Services** instance in your target subscription (in any resource group) and accept all ethical AI Terms and Conditions.
   - **After it deploys**, you can **delete it**. You only needed to do this to accept all AI Terms and Conditions for your subscription. If terms and conditions change in the future, you will need to repeat this process, which cannot be scripted.
   - Confirm again that you have rights in the target subscription to create and delete deployments, create resources and resource groups, and modify permissions.
   - Confirm again that you have rights in the target tenant to deploy service principals (enterprise apps and app registrations).
3. In your **browser**, log into **Github**.
4. Navigate to **https://github.com/microsoft/PubSec-Info-Assistant**
5. If you want your configuration changes to be saved for later repeated deployments, **fork the repo to your own GitHub account**.
6. If you forked the repository, **navigate to your fork** under your repositories.
7. **Browse** to the **docs/deployment/deployment.md** file in the repo.
8. **Click on the icon** near the top of the document to **deploy using GitHub Codespaces**.
9. Check above the top box and, **if there's a message** "Single sign-on to see codespaces for accounts within the Microsoft Open Source enterprise", **click the single sign-on link to authenticate**.
10. Select the following:
   - **Your forked repo** if you forked it (e.g., {username}/PubSec-Info-Assistant) or the original repo (microsoft/PubSec-Info-Assistant). *If neither is immediately visible, you will have to type the path*.
   - Select the **Main branch**.
   - Select the dev container configuration (**info-asst**).
   - Select the region (e.g., **useast**).
   - Select the machine type (**4-core** recommended).
11. Click the **Create codespace** button.
12. **Wait** until it's set up. (**Approximately 5.5 minutes** if using a 4-core codespace.)

---

**NOTE**: *If container setup fails and you receive a message stating you are running in recovery mode, follow the instructions in the terminal to attempt to rebuild the container. This should take much less time.*

---

13. **Favorite** the URL of your temporary codespace environment, to make it easy to return to (e.g. https://upgraded-meme-w95p5695pp43995q.github.dev/).
14. Optional but **strongly recommended**:
   - Open your local copy of VS Code.
   - Ensure the Github Codespaces extension is installed.
   - Click the Remote Explorer icon on the left bar.
   - Authenticate to Github, if you haven't already.
   - Select the codespace that's named the same as the two randomly-selected words in the URL of the codespace in the browser (which you favorited). e.g., "upgraded meme" or "ubiquitous acorn"
   - Continue the following steps in VS Code rather than the browser…
15. Navigate to scripts/environments 
16. Copy the local.env.example file to the same folder.
17. **Rename** the copied file to **local.env**.
18. **Modify** the following settings in the file:

| System Variable                        | Value                                                                     |
|----------------------------------------|---------------------------------------------------------------------------|
| LOCATION                               | usgovvirginia (or whatever region you're deploying to)                    |
| WORKSPACE                              | {a short name unique to you, try to keep to 8 characters or less}         |
| SUBSCRIPTION_ID                        | {ID of the subscription you're deploying to}<br>Azure Portal > Home > Subscriptions > {your subscription} |
| TENANT_ID                              | {ID of the tenant you're deploying to}<br>Azure Portal > Home > Entra ID  |
| AZURE_OPENAI_RESOURCE_GROUP            | {resource group in Azure Commercial containing the Azure OpenAI instance} |
| AZURE_OPENAI_SERVICE_NAME              | {name of your OpenAI instance in Azure Commercial}                        |
| AZURE_OPENAI_SERVICE_KEY               | {one of the two keys of your OpenAI instance}<br>(Resource Management > Keys and Endpoint) |
| AZURE_OPENAI_CHATGPT_DEPLOYMENT        | {name you gave your gpt-35-turbo model}<br>(OpenAI Instance > Overview > Azure OpenAI Studio) |
| AZURE_OPENAI_EMBEDDING_DEPLOYMENT_NAME | {name you gave your text-embedding-ada-002 model}<br>(OpenAI Instance > Overview > Azure OpenAI Studio) |
| IS_USGOV_DEPLOYMENT                    | **true** or **false** depending on which cloud you're deploying the resources to. |
   
19. If you are pointing to an existing OpenAI instance, you will also need to modify the following in the file:

| System Variable                        | Value                                              |
|----------------------------------------|----------------------------------------------------|
| USE_EXISTING_AOAI                      | true                                               |

20. If you are pointing to an existing AOAI instance, and it is not in the same subscription as where you're deploying your resources, you will need to update the following (using whatever models and version you deployed in OpenAI Studio):

| AZURE_OPENAI_CHATGPT_MODEL_NAME        | gpt-35-turbo                                       |
| AZURE_OPENAI_CHATGPT_MODEL_VERSION     | 0301                                               |
| AZURE_OPENAI_EMBEDDINGS_MODEL_NAME     | text-embedding-ada-002                             |
| AZURE_OPENAI_EMBEDDINGS_MODEL_VERSION  | 2                                                  |

21. **Save** the file.
22. If you're deploying to Azure Government, run the following command in the console (open console with Terminal > New Terminal):

```css
az cloud set --name AzureUSGovernment
```

23.  Now you need to **authenticate** and **target the correct subscription** and tenant. Use the following commands in the terminal to:
   -  Authenticate
   -  View the list of subscriptions.
   -  Set the correct target subscription (the same one you added to the local.env file).
   -  Confirm your session is now configured to deploy to that subscription.

```css
az login --use-device-code
az account list
az account set --subscription {your target subscription id}
az account show
```

24.  **Deploy** your resources by running the following command:

```
make deploy
```

25. **Wait** for a prompt. It should take about **1 &half; minutes**.
26. When prompted with "Are you happy with the plan? Would you like to apply?" **type y** and then **press Enter**.
27. **Wait** for the deployment to complete successfully, up to **31 minutes**.

---

28. **After deployment completes**, go to the Azure portal.
29. Navigate to the **resource group** you're deploying to and note the five-character generated string appended to most of the resource names.
30. Navigate to the **infoasst_web_access_xxxxx Enterprise Application** in **Microsoft Entre ID** (where 'xxxxx' is the same generated suffix used for your resources).
   - Note:  You may need to delete the filter to only show Application type of "Enterprise Application".
31. Open the enterprise application, then go to **Manage > Users and Groups**
32. **Add yourself** as a user.
33. If you want to make your application accessible to anyone in your directory (tenant):
   - Go to Manage > Properties
   - Change "Assignment Required?" to "No" if it isn't already. If it's set to "Yes" then only the users/groups you added in the previous step will have access.
34. Navigate to the **infoasst-web-xxxx Web App** resource in the portal, and **click on the URL for the website**.
   - If permissions are requested, accept.
   - If the website reports an Application Error, check your env file, fix any errors, and run `make deploy` again.
   - If the website reports a redirect URL mismatch, check the redirect URI in the infoasst_web_access_xxxxx app registration and ensure you change .net to .us, if deploying to Azure Government.
   - To aid in troubleshooting, you can navigate to the logstream using KUDU (scm) at:  https://infoasst-web-xxxxx.scm.azurewebsites.us/api/logstream
   - Note that Application Insights may be helpful in troubleshooting.

## Troubleshooting

- If you are prompted to log into the following URL, use the following command to do so:
   - `az login --scope https://graph.microsoft.com//.default`
- If you get the following error, you probably didn't set IS_USGOV_DEPLOYMENT to true when deploying to Azure Government:
   - `deployment failed with SpecialFeatureOrQuotaIdRequired","message":"The subscription does not have QuotaId/Feature required by SKU 'S0' from kind 'OpenAI' or contains blocked QuotaId/Feature."`
- Fix the redirect URI, if you receive errors stating that it is incorrect:
   - Navigate to the App Registrations section of Entra ID.
   - Find your infoasst_web_access_xxxxx application registration and open it.
   - Go to Manage > Authentication.
   - Confirm the URI ends with .net in Azure Commercial deployments or .us for Azure Government deployments, then click the Save button.

# Usage and Demo

## Ingesting Data

1. Ensure you have not scaled down your resources.  If you have, scale the back up again.
2. From your PubSec Info Assistant's webpage, navigate to **Manage Content** in the upper right corner.
3. Partition and categorize data using **folders** and **tags**.
4. Each tag is added by typing it then pressing enter.  Tags can include spaces.
5. Select the **file(s)** that should be associated with both the folder and the tag(s), then **upload** them.
6. Track the state under the **Upload Status** tab in the Manage Content page.  This page *does not refresh automatically*.
7. They should proceed from **Uploaded** to alternating between **Queued and Indexing** to **Complete**.  While queued and indexing, they are being processed in the enrichment pipeline, so expect them to alternate between these states for some time.  This process involves extracting data from files (structure and unstructured), chunking it, encoding, creating vectorized <a href="https://help.openai.com/en/articles/6824809-embeddings-frequently-asked-questions">embeddings</a> of the <a href="https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them">tokens</a>, and storing them.  A tokenizer tool to help you see how sentences are tokenized in English is located <a href="https://platform.openai.com/tokenizer">here</a>.
   - Note:  A state of **Error** is also possible.

## UI Title and Banner

You can adjust the title on the main page and the banner in your local.env file:

The `APPLICATION_TITLE` environment variable sets the title at the top of the page.
The `CHAT_WARNING_BANNER_TEXT` environment variable sets the banner text at the top of the page.

## Changing the PubSec Info Assistant's Behavior

### Chat Settings

1. Go to Chat in the upper right corner.
2. Click the Adjust icon.
3. Make changes:
   - Response Length is also known as "Top P" or "Nucleus Sampling" and determines how succinct or verbose the response will be.
   - Conversation Type is also known as "Temperature" and determines how constrained or "creative" the response will be.


### System Message

The system message is an initial "query" made behind the scenes automatically to instruct the LLM on how it should interact with the user.  The system message from the PubSec Info Assistant is shown below.

```python
system_message_chat_conversation = """You are an Azure OpenAI Completion system. Your persona is {systemPersona} who helps answer questions about an agency's data. {response_length_prompt}
    User persona is {userPersona} Answer ONLY with the facts listed in the list of sources below in {query_term_language} with citations.If there isn't enough information below, say you don't know and do not give citations. For tabular information return it as an html table. Do not return markdown format.
    Your goal is to provide answers based on the facts listed below in the provided source documents. Avoid making assumptions,generating speculative or generalized information or adding personal opinions.
       
    
    Each source has a file name followed by a pipe character and the actual information.Use square brackets to reference the source, e.g. [info1.txt]. Do not combine sources, list each source separately, e.g. [info1.txt][info2.pdf].
    Never cite the source content using the examples provided in this paragraph that start with info.
      
    Here is how you should answer every question:
    
    -Look for information in the source documents to answer the question in {query_term_language}.
    -If the source document has an answer, please respond with citation.You must include a citation to each document referenced only once when you find answer in source documents.      
    -If you cannot find answer in below sources, respond with I am not sure.Do not provide personal opinions or assumptions and do not include citations.
    
    {follow_up_questions_prompt}
    {injected_prompt}
    
    """
follow_up_questions_prompt_content = """
    Generate three very brief follow-up questions that the user would likely ask next about their agencies data. Use triple angle brackets to reference the questions, e.g. <<<Are there exclusions for prescriptions?>>>. Try not to repeat questions that have already been asked.
    Only generate questions and do not generate any text before or after the questions, such as 'Next Questions'
    """
```

This system message is located in app > backend > approaches > chatreadretrieveread.py

You'll notice that it references other strings, some of which include:

- systemPersona: This is the system personal configured via the GUI.
- userPersona: This is the user personal configured via the GUI.
- response_length_prompt: This will resolve to one of the three following prompts, depending on what was selected in the GUI.  The code for this is located near the bottom of the chatreadretrieveread.py file, in the get_response_length_prompt_text() function.
   - Please provide a succinct answer. This means that your answer should be no more than 1024 tokens long.
   - Please provide a standard answer. This means that your answer should be no more than 2048 tokens long.
   - Please provide a thorough answer. This means that your answer should be no more than 3072 tokens long.
- query_term_language: The language the system is configured to use (default is English).
- follow_up_questions_prompt: This will be the content of the follow_up_questions_prompt_content variable, if suggest_followup_questions is set to true.

There is also a query_prompt_template defined in the file, which is used for subsequent queries to maintain chain of thought:

```python

    query_prompt_template = """Below is a history of the conversation so far, and a new question asked by the user that needs to be answered by searching in source documents.
    Generate a search query based on the conversation and the new question. Treat each search term as an individual keyword. Do not combine terms in quotes or brackets.
    Do not include cited source filenames and document names e.g info.txt or doc.pdf in the search query terms.
    Do not include any text inside [] or <<<>>> in the search query terms.
    Do not include any special characters like '+'.
    If the question is not in {query_term_language}, translate the question to {query_term_language} before generating the search query.
    If you cannot generate a search query, return just the number 0.
    """
```

Lastly, there are some few-shot prompts included in the file as well:

```python
    #Few Shot prompting for Keyword Search Query
    query_prompt_few_shots = [
    {'role' : USER, 'content' : 'What are the future plans for public transportation development?' },
    {'role' : ASSISTANT, 'content' : 'Future plans for public transportation' },
    {'role' : USER, 'content' : 'how much renewable energy was generated last year?' },
    {'role' : ASSISTANT, 'content' : 'Renewable energy generation last year' }
    ]

    #Few Shot prompting for Response. This will feed into Chain of thought system message.
    response_prompt_few_shots = [
    {"role": USER ,'content': 'I am looking for information in source documents'},
    {'role': ASSISTANT, 'content': 'user is looking for information in source documents. Do not provide answers that are not in the source documents'},
    {'role': USER, 'content': 'What steps are being taken to promote energy conservation?'},
    {'role': ASSISTANT, 'content': 'Several steps are being taken to promote energy conservation including reducing energy consumption, increasing energy efficiency, and increasing the use of renewable energy sources.Citations[File0]'}
    ]
```


## Thought Process

To see how an answer was generated, click one of the citations or one of the icons in the corner of the response. A pane will open to the right. Click on the Thought Process tab.

## Prompt Engineering

Note that all of the following will require you to have provided grounding data (uploaded files) that have completed the enrichment pipeline, and that you queries pertain to that data.

- Make a query, then make a second query that references the same context implicitly.  For example: "What are three of the top Baseball teams of all time?" then "What is a fourth one?"  This second question doesn't explicitly mention baseball, but due to Chain of Thought the previous query and response will be sent along with the second query, allowing OpenAI to "understand" the context.
- Make a query, but ask for it in another language.  You'll note that it is capable of translating on-the-fly to other languages, which can greatly benefit staff who don't speak English as their primary language.
- Make a query, but ask for it in another language and font.  This is just for fun, to show you what it is capable of understanding.
- As it to tell a joke about the grounded data.
- Ask for data, but request that it be in a markdown table format.
- Do the same, but ask for a bulleted list.
- Ask for a summary of some subject.

## Saving Money

Some of the services can be quite expensive.  You can control costs by resizing several services, within the same family, when they are not in use.

Make sure to only do these after you've ingested your grounding data.  Otherwise ingestion will be very slow.

- Go to the Function App > Settings > Scale Up and change it from Standard S2 to Standard S1.
- Go to the Search Service > Settings > Scale and ensure Replicas is set to 1 and Partitions is set to 25 GB.
- Go to the "Enrichmentweb" Web App > Settings > Scale Up and change it from Premium v3 P1V3 to Premium v3 P0V3.
- Go to the "web" Web App > Settings > Scale Up and confirm it's set to Standard S1.

You'll want to ensure these services aren't scaled below the minimums needed to ingest or search your data when it's time to perform either task.

# Infrastructure

Note: Media Services only exists because AI Video Indexer currently uses its endpoints, soon to be replaced with Partner Solutions.

Depending on if you're deploying to Azure Commercial or Azure government, you should have the following resources after a successful deployment.  20 in Commercial or 21 in Government, plus the AOAI instance (which may be in the same or a different resource group, depending on what you specified in the env file).

Note: At this time that there is a maximum of one AOAI instance per subscription per region.

| Name                                    | Type                                    | Environment(s)        |
|-----------------------------------------|-----------------------------------------|-----------------------|
| Application Insights Smart Detection    | Action Group                            | *Gov*                 |
| infoasst-enrichmentweb-xxxxx            | App Service                             | *Gov*; **Commercial** |
| infoasst-web-xxxxx                      | App Service                             | *Gov*; **Commercial** |
| infoasst-asp-xxxxx                      | App Service Plan                        | *Gov*; **Commercial** |
| infoasst-enrichmentasp-xxxxx            | App Service Plan                        | *Gov*; **Commercial** |
| infoasst-func-asp-xxxxx                 | App Service Plan                        | *Gov*; **Commercial** |
| infoasst-ai-xxxxx                       | Application Insights                    | *Gov*; **Commercial** |
| infoasst-enrichment-cog-xxxxx           | Azure AI Services Multi-Service Account | *Gov*; **Commercial** |
| infoasst-cog-xxxxx                      | Azure AI Services Multi-Service Account | **Commercial**        |
| infoasstvi-xxxxx                        | Azure AI Video Indexer                  | *Gov*; **Commercial** |
| infoasst-cosmos-xxxxx                   | Azure Cosmos DB account                 | *Gov*: **Commercial** |
| infoasst-lw-xxxxx                       | Azure Workbook Template                 | *Gov*: **Commercial** |
| infoasst-fr-xxxxx                       | Document intelligence                   | *Gov*: **Commercial** |
| infoasst-func-xxxxx                     | Function App                            | *Gov*: **Commercial** |
| infoasst-kv-xxxxx                       | Key Vault                               | *Gov*                 |
| infoasst-la-xxxxx                       | Log Analytics Workspace                 | *Gov*: **Commercial** |
| infoasstmediasvcxxxxx                   | Media Service                           | *Gov*: **Commercial** |
| infoasst-search-xxxxx                   | Search Service                          | *Gov*: **Commercial** |
| Failure Anomalies - infoasst-ai-xxxxx   | Smart detector alert rule               | *Gov*: **Commercial** |
| infoasststorexxxxx                      | Storage account                         | *Gov*: **Commercial** |
| infoasststoremediaxxxxx                 | Storage account                         | *Gov*: **Commercial** |
| default (infoasstmediasvcxxxxx/default) | Streaming Endpoint                      | *Gov*: **Commercial** |

# Appendix

For those who are interested, there are 16 primitive Pythagorean triples of numbers up to 100:

(3, 4, 5) (5, 12, 13) (8, 15, 17) (7, 24, 25)
(20, 21, 29) (12, 35, 37) (9, 40, 41) (28, 45, 53)
(11, 60, 61) (16, 63, 65) (33, 56, 65) (48, 55, 73)
(13, 84, 85) (36, 77, 85) (39, 80, 89) (65, 72, 97)