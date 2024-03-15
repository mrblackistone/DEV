# Table of Contents

<!-- TOC -->

- [Table of Contents](#table-of-contents)
- [Purpose](#purpose)
- [Lexicon](#lexicon)
  - [Solutions](#solutions)
  - [Models](#models)
  - [Mathematical Concepts](#mathematical-concepts)
  - [Chunking, Tokenization, and Embedding](#chunking-tokenization-and-embedding)
    - [Tokenization Example](#tokenization-example)
  - [Queries and Responses](#queries-and-responses)
  - [Search](#search)
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
  - [Supporting Content](#supporting-content)
  - [Prompt Engineering](#prompt-engineering)
  - [Saving Money](#saving-money)
- [Infrastructure](#infrastructure)

<!-- /TOC -->
<!-- /TOC -->

---
---

# Purpose


The objective of this document is to consolidate information related to OpenAI in general, Azure OpenAI specifically, generative AI concepts, and the utilization of Microsoft’s PubSec Info Assistant offering. The goal is to learn how to deploy, configure, and effectively use generative AI in a production environment.

---
---

# Lexicon

In order to maximize the benefits from this document, it’s essential to familiarize yourself with the terminology used. Some terms may be unfamiliar, while others might have distinct meanings in the context of generative AI compared to what you’re accustomed to.

## Solutions

- **Information Assistant Accelerator** - Another name for the PubSec Info Assistant, a proof-of-concept made publicly available on GitHub for educational purposes and targeted at Public Sector application teams. The Information Assistant Accelerator is meant to demonstrate how a complete generative-AI system should be architected, how it can be deployed, and concepts relating to user interactions with it such as the effect of changing the "Response Length" and "Conversation Type" settings as well as the "System Message".


## Models

- **Machine Learning Model** - A machine learning model can be used to recognize patterns or make predictions based on data.
- **Generative Model** - A <a target="_blank" href="https://openai.com/research/generative-models">generative model</a> is a type of machine learning model that aims to learn the underlying patterns or distributions of data in order to generate new, similar data.
- **Parameter** - Parameters are adjustable elements in a model that are learned from training data.
- **Checkpoint** - A checkpoint is a snapshot of a trained model's parameters (weights and biases) at a specific point during training.

More details ...

- **Machine Learning Model**
   - A machine learning model is created by training a machine learning algorithm with data. This training process means that the original data is not explicitly stored or contained within the model itself, but rather influences the strength of connections generated within the model. Machine learning models are useful for many applications, such as image recognition, natural language processing, recommendation systems, and more.
- **Generative Model**
   - Text generation models include GPT 3.5 and 4.
- **Parameter**
   - These include weights in neural networks and settings in machine learning algorithms. Parameters influence the behavior of AI models and determine how they make predictions or decisions. The total number of parameters in a model is influenced by various factors such as the model's structure, the number of layers of neurons, and the complexity of the model.
   - ChatGPT 3.5 is made up of 175 Billion parameters.
   - ChatGPT 4 is far larger, at over 100 Trillion parameters.
- **Checkpoint** - A checkpoint is a snapshot of a trained model's parameters (weights and biases) at a specific point during training.

## Mathematical Concepts

- **Vector** - A quantity that has a magnitude and direction.
- **Dimensions** - The number of independent parameters or coordinates that are needed for defining the position of a point that is constrained to be in a given mathematical space.
- **Vector database** - A <a target="_blank" href="https://learn.microsoft.com/en-us/azure/cosmos-db/vector-database">vector database</a> is a database designed to store and manage vectors.
- **Cosine similarity** - Azure OpenAI embeddings rely on <a target="_blank" href="https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/understand-embeddings">cosine similarity</a> to compute similarity between documents and a query.

More details ...

- **Vector**
   - Think of a vector as an arrow that has a defined length and points in a specific direction from a given starting point.
   - In OpenAI, a vector is represented as an array (ordered list) of floating point numbers, such as: [-0.344243, 1.432833, -0.002331]
   - The length of the array corresponds to the number of dimensions. The example on the previous line is 3-dimensional.
   - For instance, the array [8.0, 15.0] corresponds to a 2-vector (2-dimensional vector) having magnitude (length) 17.
      - (8: 15 :17 is a pythagorean triple, as 8<sup>2</sup> + 15<sup>2</sup> = 17<sup>2</sup>).
   - A graphical representation of a two-dimensional vector is shown below.

<center><br><br><img src="images/Vector 3-4.png" width=25%><br>Figure 1: A 2-vector where v = (3, 4)<br><br></center>

- **Dimensions**
   - Identifying a specific location along the number line requires just one number. Therefore, the number line is one-dimensional.
   - The ada 2 embedding model has 1,536 dimensions, which is much larger than the two-dimensional example above, and is impossible for a person to visualize.
   - These larger dimensional spaces are what allow for the intricacies and nuances of language to be captured more accurately when embedding or training.
   - In order to compare vectors, they must be the same number of dimensions.  As such, for a given embedding model and version, each embedding will have the same number of dimensions regardless of the number of tokens it represents.
- **Vector database**
   - Vector embeddings are mathematical representations of data in a high-dimensional space.
   - In this space, each dimension corresponds to a feature of the data, and in some cases tens of thousands of dimensions might be used to represent sophisticated data.
   - A vector's position in this space represents its characteristics.
   - Words, phrases, or entire documents, and images, audio, and other types of data can all be vectorized.
   - These vector embeddings are used in similarity search, multi-modal search, recommendations engines, large languages models (LLMs), etc.
- **Cosine similarity**
   - From a mathematic perspective, cosine similarity measures the cosine of the angle between two vectors projected in a multidimensional space.
   - This measurement is beneficial because if two documents are far apart by Euclidean distance due to size they could still have a smaller angle between them and therefore a higher computed cosine similarity.
   - Note that OpenAI embeddings are <a target="_blank" href="https://platform.openai.com/docs/guides/embeddings/frequently-asked-questions">normalized to length 1</a>, which means that cosine similarity can be computed a bit faster using only a dot product, and that cosine similarity and Euclidean distance will result in identical rankings.
   - "Dot product" is the sum of the products of multiplying each element in equal-length arrays, for instance: a<sub>1</sub>b<sub>1</sub> + a<sub>2</sub>b<sub>2</sub> + ... a<sub>n</sub>b<sub>n</sub>

## Chunking, Tokenization, and Embedding

- **Token** - A <a target="_blank" href=https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them>token</a> is a single piece of text from an input that is associated (embedded) as a particular value in a vector.
- **Embedding** - An <a target="_blank" href="https://platform.openai.com/docs/guides/embeddings">embedding</a> is a special format of data representation that can be easily utilized by machine learning models and algorithms.
- **Chunk/chunking** - Due to token limits, the documents that the PubSec Info Assistant ingests are <a target="_blank" href="https://learn.microsoft.com/en-us/azure/search/vector-search-how-to-chunk-documents">chunked</a> (broken up) and pre-processed into a format that's easier to use, especially complex file types like PDF.

More details ...

- **Token**
   - Tokens can include words with specific capitalization, sub-words, or punctuation. For instance, the sentence "Jake likes to eat, especially cake." might be broken out into the following tokens:
   - A word not preceded by a space, starting with a capital letter: "**Jake**"
   - A word preceded by a space, starting with a lower-case letter: " **likes**"
   - A word preceded by a space, starting with a lower-case letter: " **to**"
   - A word preceded by a space, starting with a lower-case letter: " **eat**"
   - A comma:  "**,**"
   - A word preceded by a space, starting with a lower-case letter: " **especially**"
   - A word preceded by a space, starting with a lower-case letter: " **cake**"
   - A period: "**.**"
   - You can see how text is tokenized by OpenAI using <a target="_blank" href="https://platform.openai.com/tokenizer">this tool</a>.
   - For English, a good rule-of-thumb is that there are 0.75 words per token. Other languages will typically require a greater number of tokens.
- **Embedding**
   - The embedding is an information-dense representation of the semantic meaning of a piece of text.
   - Each embedding is a vector of floating point numbers, such that the distance between two embeddings in the vector space is correlated with semantic similarity between two inputs in the original format.
   - Depending on the system, each Token may be assigned a specific number in the vector.
   - There are also limits associated with tokenization models, for instance <a target="_blank" href="https://openai.com/blog/new-and-improved-embedding-model">Ada 2</a> supports up to 8191 tokens at a time, and ChatGPT has a token limit shared between prompt and completion that varies with model and version.
- **Chunk/chunking**
   - The PDF files are processed through Azure AI Document Intelligence, whereas other file types are processed through Unstructured.io, both of which result in JSON-based representations.
   - Pre-processing status is logged in Cosmos DB.
   - Chunking can also include overlap, to ensure that data is not split across chunks when it shouldn't be.
   - Note that OpenAI typically performs better when documents are chunked by section rather than by page, paragraph, or fixed sizes.
   - Other options to chunk documents include <a target="_blank" href="https://python.langchain.com/en/latest/index.html">LangChain</a> and <a target="_blank" href="https://github.com/microsoft/semantic-kernel">Semantic Kernel</a>.

### Tokenization Example

- The Tokens before embedding: ["**Jake**", " **likes**", " **to**", " **eat**", "**,**", " **especially**", " **cake**", "**.**"]
- After embedding: [**7.438294**, **-0.782139**, **1.728197**, **-4.278129**, **-1.743892**, **6.273129**, **2.237180**, **9.728193**]

Note:  This is purely a generic example to present a concept. These are not necessarily the values that would be generated in an actual OpenAI or similar system. For instance, ada-2 has a fixed output dimension of 1,536 rather than the eight presented here.
   - You can learn more about embeddings at <a target="_blank" href="https://learn.microsoft.com/en-us/azure/ai-services/openai/tutorials/embeddings?tabs=python%2Ccommand-line&pivots=programming-language-python">this link</a>.



## Queries and Responses

- **Grounding** - <a target="_blank" href="https://techcommunity.microsoft.com/t5/fasttrack-for-azure/grounding-llms/ba-p/3843857">Grounding</a> is the process of using large language models (LLMs) with information that is use-case specific, relevant, and not available as part of the LLM's trained knowledge.
- **Retrieval Augmented Generation (RAG)** - <a target="_blank" href="https://learn.microsoft.com/en-us/azure/search/retrieval-augmented-generation-overview">Retrieval Augmentation Generation (RAG)</a> is an architecture that augments the capabilities of a Large Language Model (LLM) like ChatGPT by adding an information retrieval system that provides grounding data.
- **Persona** - A persona is the "tone" and language used by the AI, such as "an Assistant" or "a Teacher", which makes interacting with the LLM less impersonal.
- **Chain of Thought** - Chain of Thought refers to the need with each new query in a session to include all previous questions and answers.
- **Session** - A session is a single Chain of Thought, meaning when all previous requests and responses are included with each new request, and impact how the AI responds.
- **System Message/Metaprompt** - A system message is an optional (but highly recommended) initial message sent automatically in every new session.
- **Enrichment Pipeline** - The Enrichment Pipeline is the process of ingesting, parsing, and chunking input data, then embedding/vectorizing it, so the PubSec Info Assistant will be able to provide relevant responses to queries.
- **Temperature** or **Conversation Type** - Temperature adjusts the randomness of a model's output, where a low temperature results in predictable and tightly scoped responses, and a high temperature results in varied and creative responses.
- **Response Length** - This option in the application's answer generation configuration pane limits the length of responses to a defined number of tokens.
- **Top_p** - While this OpenAI API option is unused in the PubSec Info Assistant, it is similar to the "Response Length" option in that it helps to generate short, specific answers.

More details ...

- **Grounding**
   - LLMs are not databases, but rather engines for general reasoning and text generation.  Grounding allows us to provide specific, often private, data that the LLM engine can then use to generate insights relating to that data which are accurate and specific.
- **Retrieval Augmented Generation (RAG)**
   - RAG, in the PubSec Info Assistant, utilizes Azure AI Search's Vector Hybrid Search capabilities to retrieve documents that are contextually relevant for precise answers.
   - This approach empowers you to find relevant information efficiently by combining the strengths of both semantic vectors and keywords.
   - As such, you don't have to go through the immense time and expense of training your own model.
- **Persona**
   - Depending on the LLM used, the persona can impact how it presents responses to varying degrees.
- **Chain of Thought**
   - This stems from the absence of persistent "memory" in the OpenAI instance as to your previous queries.
   - This allows OpenAI to provide contextually-appropriate responses based on the conversation so far, without having to store your previous queries or its own responses to them.
- **Session**
   - To eliminate the effect of previous interactions on future responses, you must start a new session, which resets the Chain of Thought.
   - This is particularly important when shifting focus to a new subject that has little or nothing to do with the queries you've made so far.
- **System Message/Metaprompt**
   - It tells the system how responses should be constructed, what kind of persona the system and user should have, etc.
   - This is typically hidden from the user, but is made visible in the PubSec Info Assistant for educational purposes.
   - **X-Shot** - The System Message can include zero-shot, one-shot, or few-shot example interactions, as defined below:
      - **One-shot** - One-shot is when a single example interaction is provided in the system message.
      - **Few-shot** - Few-shot is when more than one example interaction is provided in the system message, though it should consist of three or more examples, because providing only two appears to afford no benefit over just a single shot.
      - **Zero-shot** - Zero-shot is when no example interactions are provided in the system message.
- **Temperature** or **Conversation Type**
   - The "Conversation Type" selection in the application's answer generation configuration pane is also known as "Temperature", which is an option in OpenAI's API.
   - Temperature affects the probabilities over all possible tokens during each step of the generation process. At 0 the process is completely deterministic, always sticking with the most likely token.
   - Depending on what you set it to, the value will be 0.0, 0.6, or 1.0, represented as "Precise", "Balanced", and "Creative" respectively.
- **Top_p**
   - Also known as Nucleus Sampling
   - Top_p sampling, instead of considering all tokens, considers instead only a subset of tokens (the "nucleus"). As such it is also known as nucleus sampling.
   - Unlike "Response Length", it should be considered an **alternative** to "Temperature" and not adjusted at the same time.


## Search

- **Azure AI Search** - This accelerator employs Vector Hybrid Search, which combines vector similarity with keyword matching to enhance search accuracy.
- **Types of Search Methods** - For the Information Assistant Accelerator, only Vector search is currently available (Feb 21, 2024).

More details ...

- **Azure AI Search**
   - This approach empowers you to find relevant information efficiently by combining the strengths of both semantic vectors and keywords.
   - Note that in Azure Government keyword search is not yet available as of Feb 21, 2024.
- **Types of Search Methods**
   - **Vector** - <a target="_blank" href="https://learn.microsoft.com/en-us/azure/search/vector-search-overview">Vector search</a> is an approach in information retrieval that stores numeric representations of content for search scenarios.
      - Because the content is numeric rather than plain text, the search engine matches on vectors that are the most similar to the query, with no requirement for matching on exact terms.
   - **Hybrid** - Hybrid search is a combination of full text and vector queries that execute against a search index that contains both searchable plain text content and generated embeddings. For query purposes, hybrid search is:
      - A single query request that includes both search and vectors query parameters
      - Executing in parallel
      - With merged results in the query response, scored using Reciprocal Rank Fusion (RRF)
   - **Full Text** - A full-text search is a comprehensive method that compares every word of the search request against every word within a document or database.
   - **Keyword** - Keyword search looks for exact matches of words, but lacks semantic understanding.
   - **Semantic Ranker** (proprietary in Azure AI Search) - In Azure AI Search, semantic ranking measurably improves search relevance by using language understanding to rerank search results.
      - Semantic ranking doesn't use generative AI or vectors.
      - Semantic ranker is a collection of query-related capabilities that improve the quality of an initial BM25-ranked or RRF-ranked search result for text-based queries.
      - When you enable it on your search service, semantic ranking extends the query execution pipeline in two ways:
         - First, it adds secondary ranking over an initial result set that was scored using BM25 or RRF. This secondary ranking uses multi-lingual, deep learning models adapted from Microsoft Bing to promote the most semantically relevant results.
         - Second, it extracts and returns captions and answers in the response, which you can render on a search page to improve the user's search experience.

---
---

# PubSec Info Assistant

The PubSec Info Assistant is a ready-to-use teaching tool which deploys a functional Azure OpenAI application into a target Azure environment. It is designed with application teams in mind so they can learn how to deploy, modify, and use an Azure OpenAI ChatGPT application that uses grounding data to provide answers specific to the organization's data, without the need to train their own model.

IMPORTANT: Some customers may say they need to "train the model" when speaking about LLMs, but in reality what you are doing is "grounding the responses" using your data. Microsoft does not use your data to train Azure OpenAI or M365 Copilot.

All up-to-date official documentation is located in the repository. This section consolidates information from that documentation, but is only a point-in-time collection, and should not be regarded as the official source of information.

NOTE:  The instructions are written for all of the following scenarios. Confirm which scenario is applicable to you before starting, and keep it in mind as you progress through the steps:
- The PubSec Info Assistant's resources and an Azure OpenAI (AOAI) instance will be deployed to a single resource group. (Requires that no AOAI instance already exists in the same subscription.)
- The PubSec Info Assistant's resources will be deployed, and will use an existing AOAI instance in the same tenant.
- The PubSec Info Assistant's resources will be deployed, and will use an existing AOAI instance in the a different tenant or cloud.

## Pre-requisites

1. An **Azure Tenant** where you have permissions to:
   - **Create service principals** (applications).
2. Az **Azure subscription** in that tenant where you have submitted a request for approval to deploy Azure OpenAI, and that approval has been granted by Microsoft.
3. An **Azure subscription** in that same tenant where you have rights to:
   - **Change permissions**
   - **Deploy resources**
   - **Delete deployments**
   - **Create resource groups**
4. An **Azure Tenant** (the same one or a different one) **and Subscription** where you have permissions to:
   - **Deploy and read an Azure OpenAI instance**, **or**
   - One is already deployed and you have access to **read its name, key, and can get into the OpenAI studio to set up model deployments**.
5. A **Github account**.
6. Optional, but strongly recommended:  **VS Code w/ GitHub Workspaces extension** loaded on your local system.
7. If you've deployed before from a forked repository, make sure you update it with the most recent changes from the original repository before going through these instructions again.

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
9. Check above the top box and, **if there's a message** "Single sign-on to see Codespaces for accounts within the Microsoft Open Source enterprise", **click the single sign-on link to authenticate**.
10. Select the following:
   - **Your forked repo** if you forked it (e.g., {username}/PubSec-Info-Assistant) or the original repo (microsoft/PubSec-Info-Assistant). *If neither is immediately visible, you will have to type the path*.
   - Select the **Main branch**.
   - Select the dev container configuration (**info-asst**).
   - Select the region (e.g., **useast**).
   - Select the machine type (**4-core** recommended).
11. Click the **Create Codespace** button.
12. **Wait** until it's set up. (**Approximately 5.5 minutes** if using a 4-core Codespace.)

---

**NOTE**: *If container setup fails and you receive a message stating you are running in recovery mode, follow the instructions in the terminal to attempt to rebuild the container. This should take much less time.*

---

13. **Favorite** the URL of your temporary Codespace environment, to make it easy to return to (e.g. https://upgraded-meme-w95p5695pp43995q.github.dev/).
14. Optional but **strongly recommended**:
   - Open your local copy of VS Code.
   - Ensure the Github Codespaces extension is installed.
   - Click the Remote Explorer icon on the left bar.
   - Authenticate to Github, if you haven't already.
   - Select the Codespace that's named the same as the two randomly-selected words in the URL of the Codespace in the browser (which you favorited). e.g., "upgraded meme" or "ubiquitous acorn"
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

| System Variable                        | Value                                              |
|----------------------------------------|----------------------------------------------------|
| AZURE_OPENAI_CHATGPT_MODEL_NAME        | gpt-35-turbo                                       |
| AZURE_OPENAI_CHATGPT_MODEL_VERSION     | 0301                                               |
| AZURE_OPENAI_EMBEDDINGS_MODEL_NAME     | text-embedding-ada-002                             |
| AZURE_OPENAI_EMBEDDINGS_MODEL_VERSION  | 2                                                  |

21. **Save** the file.
22. If you're deploying to Azure Government, run the following command in the console (open console with `Terminal > New Terminal`):

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
   - Go to `Manage > Properties`
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

```
deployment failed with SpecialFeatureOrQuotaIdRequired","message":"The subscription does not have QuotaId/Feature required by SKU 'S0' from kind 'OpenAI' or contains blocked QuotaId/Feature."
```

- Fix the redirect URI, if you receive errors stating that it is incorrect:
   - Navigate to the App Registrations section of Entra ID.
   - Find your infoasst_web_access_xxxxx application registration and open it.
   - Go to `Manage > Authentication`.
   - Confirm the URI ends with .net in Azure Commercial deployments or .us for Azure Government deployments, then click the Save button.

---
---

# Usage and Demo

The main page will look similar to the image below.

<img src="images/Main Page Markup.png" width=75%>

Figure 1: Main Page with Important Items Labeled

## Ingesting Data

1. Ensure you have not scaled down your resources.  If you have, scale the back up again.
2. From your PubSec Info Assistant's webpage, navigate to **Manage Content** in the upper right corner.
3. Partition and categorize data using **folders** and **tags**.
4. Each tag is added by typing it then pressing enter.  Tags can include spaces.
5. Select the **file(s)** that should be associated with both the folder and the tag(s), then **upload** them.
6. Track the state under the **Upload Status** tab in the Manage Content page.  This page *does not refresh automatically*.
7. They should proceed from **Uploaded** to alternating between **Queued and Indexing** to **Complete**.  While queued and indexing, they are being processed in the enrichment pipeline, so expect them to alternate between these states for some time.  This process involves extracting data from files (structure and unstructured), chunking it, encoding, creating vectorized <a target="_blank" href="https://help.openai.com/en/articles/6824809-embeddings-frequently-asked-questions">embeddings</a> of the <a target="_blank" href="https://help.openai.com/en/articles/4936856-what-are-tokens-and-how-to-count-them">tokens</a>, and storing them.  A tokenizer tool to help you see how sentences are tokenized in English is located <a target="_blank" href="https://platform.openai.com/tokenizer">here</a>.
   - Note:  A state of **Error** is also possible.

<img src="images/Upload Files.png" width=75%>

Figure 3: Upload Files page

## UI Title and Banner

You can adjust the title on the main page and the banner in your local.env file:

- The `APPLICATION_TITLE` environment variable sets the title at the top of the page.
- The `CHAT_WARNING_BANNER_TEXT` environment variable sets the banner text at the top of the page.

## Changing the PubSec Info Assistant's Behavior

### Chat Settings

1. Click on **Chat** in the upper right corner to navigate to the Chat page.
2. Click the **Adjust** icon.
3. Make changes:
   - **User Persona** describes how the system should treat the user.
   - **System Persona** describes how the system should act.
   - **Response Length**, which is similar in effect to "top_p" or "nucleus sampling", determines how succinct or verbose the response will be by limiting the number of returned tokens.
   - **Conversation Type** is also known as "Temperature" and determines how constrained or "creative" the response will be.
   - **Folder Selection** allows you to scope the search to documents in specific folders.
   - **Tags** allows you to scope the search to documents uploaded with specific tags.
   - "Retrieve this many documents from search" and "Suggest follow-up questions" are self-explanatory.
4. Click **Close** when you are done making changes.

### System Message

The system message (AKA "metaprompt") is an initial query made behind the scenes automatically to instruct the LLM on how it should interact with the user.  An example system message from one version of the PubSec Info Assistant is shown below.

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

This system message is located in `app > backend > approaches > chatreadretrieveread.py` and you can modify it and then deploy the application code to change how the system works.

You'll notice that it references other strings, some of which include:

- **systemPersona**: This is the system personal configured via the GUI.
- **userPersona**: This is the user personal configured via the GUI.
- **response_length_prompt**: This will resolve to one of the three following prompts, depending on what was selected in the GUI.  The code for this is located near the bottom of the chatreadretrieveread.py file, in the get_response_length_prompt_text() function.
   - Please provide a **succinct** answer. This means that your answer should be no more than **1024** tokens long.
   - Please provide a **standard** answer. This means that your answer should be no more than **2048** tokens long.
   - Please provide a **thorough** answer. This means that your answer should be no more than **3072** tokens long.
- **query_term_language**: The language the system is configured to use (default is English).
- **follow_up_questions_prompt**: This will be the content of the follow_up_questions_prompt_content variable, if suggest_followup_questions is set to true.

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

- To see how an answer was generated, click one of the citations or one of the Thought Process icons (light bulb) in the corner of a response.
- A pane will open to the right. Click on the Thought Process tab, if you are on another tab.
- Close the right-hand pane by clicking on the Thought Process icon in the response box again.

<img src="images/Thought Process.png" width=75%>

Figure 4: Thought Process pane

## Supporting Content

- To see what supporting content was used to generate the answer, click on the Supporting Content icon (clipboard) in the corner of the response.
- A pane will open to the right. Click on the Supporting Content tab, if you are on another tab.
- Close the right-hand pane by clicking on the Supporting Content icon in the response box again.

<img src="images/Supporting Content.png" width=75%>

Figure 5: Supporting Content pane

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

Some of the services can be quite expensive if they are scaled larger than they need to be.  You can control costs by resizing several services, within the same tier, when they are not in use. (e.g., Premium v3 should be resized to a different size in the Premium v3 tier, Standard to Standard, etc.)

Make sure to only do these after you've ingested your grounding data.  Otherwise ingestion will be very slow.

- Go to the **Function App's** > `Settings > Scale Up` and change it from Standard S2 to Standard S1.
- Go to the **Search Service's** > `Settings > Scale` and ensure Replicas is set to 1 and Partitions is set to 25 GB.
- Go to the **"Enrichmentweb" Web App's** > `Settings > Scale Up` and change it from Premium v3 P1V3 to Premium v3 P0V3.
- Go to the **"Web" Web App's** `Settings > Scale Up` and confirm it's set to Standard S1.

You'll want to ensure these services aren't scaled below the minimums needed to ingest or search your data when it's time to perform either task.

---
---

# Infrastructure

Note: Media Services only exists because AI Video Indexer currently uses its endpoints, soon to be replaced with Partner Solutions.

Depending on if you're deploying to Azure Commercial or Azure government, you should have the following resources after a successful deployment, plus the AOAI instance (which may not be in the same resource group, subscription, and/or tenant, depending on what you specified in the env file).

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
| infoasst-cosmos-xxxxx                   | Azure Cosmos DB account                 | *Gov*: **Commercial** |
| infoasst-lw-xxxxx                       | Azure Workbook Template                 | *Gov*: **Commercial** |
| infoasst-fr-xxxxx                       | Document intelligence                   | *Gov*: **Commercial** |
| infoasst-func-xxxxx                     | Function App                            | *Gov*: **Commercial** |
| infoasst-kv-xxxxx                       | Key Vault                               | *Gov*: **Commercial** |
| infoasst-la-xxxxx                       | Log Analytics Workspace                 | *Gov*: **Commercial** |
| infoasst-search-xxxxx                   | Search Service                          | *Gov*: **Commercial** |
| Failure Anomalies - infoasst-ai-xxxxx   | Smart detector alert rule               | *Gov*: **Commercial** |
| infoasststorexxxxx                      | Storage account                         | *Gov*: **Commercial** |
| infoasststoremediaxxxxx                 | Storage account                         | *Gov*: **Commercial** |


