<!-- TOC -->

- [Purpose](#purpose)
- [Lexicon](#lexicon)
  - [Solutions](#solutions)
  - [Models](#models)
  - [Mathematics](#mathematics)
- [Chunking, Tokenization, and Embedding](#chunking-tokenization-and-embedding)
  - [Queries and Reponses](#queries-and-reponses)
  - [Search Resources](#search-resources)
- [PubSec Info Assistant](#pubsec-info-assistant)
  - [Pre-requisites](#pre-requisites)
  - [Instructions](#instructions)
  - [**NOTE**: *If container setup fails and you receive a message stating you are running in recovery mode, follow the instructions in the terminal to attempt to rebuild the container.  This should take much less time.*](#note-if-container-setup-fails-and-you-receive-a-message-stating-you-are-running-in-recovery-mode-follow-the-instructions-in-the-terminal-to-attempt-to-rebuild-the-container--this-should-take-much-less-time)
- [Demonstrations](#demonstrations)
- [Other Information](#other-information)

<!-- /TOC -->


# Purpose

The purpose of this document is to consolidate information relating to OpenAI generally, Azure OpenAI specifically, generative AI concepts, and use of the PubSec Info Assistant offering from Microsoft to learn how to deploy, configure, and use generative AI in a production environment.

# Lexicon

In order for the rest of this document to make sense, it is best to learn the terminology that is used.  Some words will be new, while others may have different meanings (in the context of generative AI) than you are used to.

## Solutions
- **Information Assistant Accelerator** - Another name for the PubSec Info Assistant, a proof-of-concept made publicly available on GitHub for educational purposes and targeted at Public Sector application teams.


## Models

- **Parameter** - In the field of artificial intelligence, parameters are adjustable elements in a model that are learned from training data. These include weights in neural networks and settings in machine learning algorithms. Parameters influence the behavior of AI models and determine how they make predictions or decisions. The total number of parameters in a model is influenced by various factors such as the model’s structure, the number of layers of neurons, and the complexity of the model. ChatGPT 3.5 is made up of 175 Billion parameters, while there are over 100 Trillion parameters in ChatGPT 4.
- **Machine Learning Model** - A machine learning model is a computer program that can recognize patterns or make predictions based on data. A machine learning model is created by training a machine learning algorithm with data, which modifies the algorithm to perform a specific task. There are different types of machine learning models, such as supervised, unsupervised, and reinforcement learning models, that use different methods and data to learn from. Machine learning models are useful for many applications, such as image recognition, natural language processing, recommendation systems, and more.
- **Generative Model** - A <a href="https://openai.com/research/generative-models">generative model</a> is a type of machine learning model that aims to learn the underlying patterns or distributions of data in order to generate new, similar data.  Some examples of generative models are:
   - Generative Adversarial Networks (GANs): These are models that consist of two networks, a generator and a discriminator, that compete with each other. The generator tries to create realistic data, while the discriminator tries to distinguish between real and fake data. By training them together, the generator can improve its ability to fool the discriminator and produce high-quality data.
   - Variational Autoencoders (VAEs): These are models that use an encoder and a decoder to learn a latent representation of the data. The encoder maps the data to a lower-dimensional space, while the decoder reconstructs the data from the latent space. The latent space is constrained to follow a certain distribution, such as a Gaussian, which allows the model to generate new data by sampling from the latent space.
   - PixelCNN: This is a model that uses a convolutional neural network to generate images pixel by pixel. The model predicts the value of each pixel based on the previous pixels in a causal order, such as from top to bottom and from left to right. The model can generate diverse and realistic images by sampling from the conditional distribution of each pixel.
- **Checkpoint** - A model that has been trained further to adjust its weights.

## Mathematics

- **Vector** - A vector is a quantity that has a magnitude and direction.  In OpenAI, a vector is represented as an array (list) of floating point numbers.  The length of the array corresponds to the vector dimension.  For instance, the vector [3.0,4.0] corresponds to a 2-vector having magnitude 5 (3: 4 :5 is a pythagorean triple, as 3<sup>2</sup> + 4<sup>2</sup> = 5<sup>2</sup>).  Therefore, the number of dimensions of the array, n, corresponds to the length of the array, an *n-array*.
- **Dimensions** - The ada 2 embedding model has only 1,536 dimensions.
- **Vector database** - A <a href="https://learn.microsoft.com/en-us/azure/cosmos-db/vector-database">vector database</a> is a database designed to store and manage vector embeddings, which are mathematical representations of data in a high-dimensional space. In this space, each dimension corresponds to a feature of the data, and tens of thousands of dimensions might be used to represent sophisticated data. A vector's position in this space represents its characteristics. Words, phrases, or entire documents, and images, audio, and other types of data can all be vectorized. These vector embeddings are used in similarity search, multi-modal search, recommendations engines, large languages models (LLMs), etc.
- **Cosine similarity** - Azure OpenAI embeddings rely on <a href="https://learn.microsoft.com/en-us/azure/ai-services/openai/concepts/understand-embeddings">cosine similarity</a> to compute similarity between documents and a query. From a mathematic perspective, cosine similarity measures the cosine of the angle between two vectors projected in a multidimensional space. This measurement is beneficial, because if two documents are far apart by Euclidean distance because of size, they could still have a smaller angle between them and therefore higher cosine similarity. However, OpenAI embeddings are <a href="https://platform.openai.com/docs/guides/embeddings/frequently-asked-questions">normalized to length 1</a>, which means that cosine similarity can be computed a bit faster using only a dot product, and that cosine similarity and Euclidean distance will result in identical rankings.


# Chunking, Tokenization, and Embedding

- **Token** - A token is a single "piece" of information from an input that is associated (embedded) as a particular value in a vector.  Ada 2 supports up to 8191 tokens at a time.  Tokens can include words with specific capitalization, sub-words, or punctuation.  For instance, the sentence "Jake likes to eat, especially cake." might be broken out into the following tokens:
   - A word not preceded by a space, starting with a capital letter: "**Jake**"
   - A word preceded by a space, starting with a lower-case letter: " **likes**"
   - A word preceded by a space, starting with a lower-case letter: " **to**"
   - A word preceded by a space, starting with a lower-case letter: " **eat**"
   - A comma:  "**,**"
   - A word preceded by a space, starting with a lower-case letter: " **especially**"
   - A word preceded by a space, starting with a lower-case letter: " **cake**"
   - A period: "**.**"
- **Embedding** - An <a href="https://platform.openai.com/docs/guides/embeddings">embedding</a> is a special format of data representation that can be easily utilized by machine learning models and algorithms. The embedding is an information dense representation of the semantic meaning of a piece of text. Each embedding is a vector of floating point numbers, such that the distance between two embeddings in the vector space is correlated with semantic similarity between two inputs in the original format.  Depending on the system, each Token may be assigned a specific number in the vector.
   - Example:  Using the previous example for Tokenization, the tokens might be imbedded thusly:
   - The Tokens before embedding: ["**Jake**", " **likes**", " **to**", " **eat**", "**,**", " **especially**", " **cake**", "**.**"]
   - After embedding: [**7.438294**, **2.782139**, **1.728197**, **4.278129**, **1.743892**, **6.273129**, **2.237180**, **9.728193**]
   - Note:  This is purely an example to present a concept.  These are not necessarily the tokens or values that would be generated in an actual OpenAI or similar system.
- **Chunk/chunking** - Due to token limits, documents are chunked (broken up) and pre-processed into a format that's easier to use, especially complex file types like PDF.  The PDF files are processed through Azure AI Document Intelligence, whereas other file types are processed through Unstructured.io, both of which result in JSON-based representations.  Pre-processing status is logged in Cosmos DB.  By default, OpenAI (when chunking documents) attempts to chunk by document section rather than by page, up to the maximum size limit.  This yields better results than chunking by page.


## Queries and Reponses

- **Retrieval Augmented Generation (RAG)** - Retrieval Augmentation Generation (RAG) is an architecture that augments the capabilities of a Large Language Model (LLM) like ChatGPT by adding an information retrieval system that provides grounding data. It allows the system to retrieve Contextually Relevant Documents by utilizing Azure AI Search's Vector Hybrid Search capabilities to retrieve documents that are contextually relevant for precise answers. This approach empowers you to find relevant information efficiently by combining the strengths of both semantic vectors and keywords.  i.e., You don't have to train the model on the documents, but you can retrieve and generate based on them anyway.
- **Persona** - The "tone" and language used by the AI, such as "an Assistant" or "a Teacher" or "a Comedian".  This impacts how it presents responses.
- **Chain of Thought** - Sending previous questions and answers in the same session.
- **Session** - A session is a single Chain of Thought, meaning when all previous requests and responses are included with each new request, and impact how the AI responds.  To eliminate the effect of previous interactions on future responses, you must start a new session, which resets the Chain of Thought.
- **Grounding** - Limiting results to a specific dataset.
- **System Message/System Prompt** - A system message is an optional (but recommended) initial message sent automatically in every session, typically hidden from the user, that tells the system how responses should be constructed, what kind of persona the system and user should have, etc.
- **One-shot** - Single example in system message (metaprompt).
- **Few-shot** - Should be three or more examples, because 2 appears to afford no benefit over just a single shot.
- **Zero-shot** - No examples
- **Enrichment Pipeline** - Ingests, parses, and chunks input files.

## Search Resources

- **Azure AI Search** - This accelerator employs Vector Hybrid Search which combines vector similarity with keyword matching to enhance search accuracy. (In Azure Government keyword search is not yet available.) This approach empowers you to find relevant information efficiently by combining the strengths of both semantic vectors and keywords.
- **Vector vs Keyword vs Semantic Ranker vs Hybrid Search** - Different search methods.  For the Information Assistant Accelerator, only Vector search is currently available (Feb 13, 2024).
   - **Vector** - <a href="https://learn.microsoft.com/en-us/azure/search/vector-search-overview">Vector search</a> is an approach in information retrieval that stores numeric representations of content for search scenarios. Because the content is numeric rather than plain text, the search engine matches on vectors that are the most similar to the query, with no requirement for matching on exact terms.
   - **Hybrid** - Hybrid search is a combination of full text and vector queries that execute against a search index that contains both searchable plain text content and generated embeddings. For query purposes, hybrid search is:
      - A single query request that includes both search and vectors query parameters
      - Executing in parallel
      - With merged results in the query response, scored using Reciprocal Rank Fusion (RRF)
   - **Keyword** - 
   - **Semantic Ranker** (proprietary in Azure AI Search) - In Azure AI Search, semantic ranking measurably improves search relevance by using language understanding to rerank search results.  Semantic ranking doesn't use generative AI or vectors.  Semantic ranker is a collection of query-related capabilities that improve the quality of an initial BM25-ranked or RRF-ranked search result for text-based queries. When you enable it on your search service, semantic ranking extends the query execution pipeline in two ways:
      - First, it adds secondary ranking over an initial result set that was scored using BM25 or RRF. This secondary ranking uses multi-lingual, deep learning models adapted from Microsoft Bing to promote the most semantically relevant results.
      - Second, it extracts and returns captions and answers in the response, which you can render on a search page to improve the user's search experience.

# PubSec Info Assistant

The PubSec Info Assistant is a ready-to-use teaching tool which deploys a functional Azure OpenAI application into a target Azure environment, designed with application teams in mind so they can learn how to deploy, modify, and use an Azure OpenAI ChatGPT application that uses grounding data to provide answers specific to the organization.

All up-to-date official documentation is located in the repository.  This section consolidates information from that documentation, but is only a point-in-time collection, and should not be regarded as the official source of information.

NOTE:  The instructions are written for all three of the following scenarios.  Confirm which scenario is applicable to you before starting, and keep it in mind as you progress through the steps:
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
   - Take note of the **model name**, **model version**, and **deployment name** you give each of them.  All three pieces of information for both of the deployments will be used later.
2. In the Azure Subscription where you will be deploying the rest of your PubSec Info Assistant resources:
   - Create an **Azure AI Services** instance in your target subscription (in any resource group) and accept all ethical AI Terms and Conditions.
   - **After it deploys**, you can **delete it**.  You only needed to do this to accept all AI Terms and Conditions for your subscription.  If terms and conditions change in the future, you will need to repeat this process, which cannot be scripted.
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
   - **Your forked repo** if you forked it (e.g., {username}/PubSec-Info-Assistant) or the original repo (microsoft/PubSec-Info-Assistant).  *If neither is immediately visible, you will have to type the path*.
   - Select the **Main branch**.
   - Select the dev container configuration (**info-asst**).
   - Select the region (e.g., **useast**).
   - Select the machine type (**4-core** recommended).
11. Click the **Create codespace** button.
12. **Wait** until it's set up.  (**Approximately 5.5 minutes** if using a 4-core codespace.)

---
**NOTE**: *If container setup fails and you receive a message stating you are running in recovery mode, follow the instructions in the terminal to attempt to rebuild the container.  This should take much less time.*
---

13.  Favorite the URL of your temporary codespace environment, to make it easy to return to (e.g. https://upgraded-meme-w95p5695pp43995q.github.dev/.
14.  Optional but strongly recommended:
   - Open your local copy of VS Code.
   - Ensure the Github Codespaces extension is installed.
   - Click the Remote Explorer icon on the left bar.
   - Authenticate to Github, if you haven't already.
   - Select the codespace that's named the same as the two randomly-selected words in the URL of the codespace in the browser (which you favorited). e.g., "upgraded meme" or "ubiquitous acorn"
   - Continue the following steps in VS Code rather than the browser…
      - Navigate to scripts/environments 
      -  Copy the local.env.example file to the same folder.
15.  Rename the copied file to local.env.
16.  Modify the following settings in the file:

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
   
17.  If you are pointing to an existing OpenAI instance, you will also need to modify the following in the file:

| System Variable                        | Value                                              |
|----------------------------------------|----------------------------------------------------|
| USE_EXISTING_AOAI                      | true                                               |

18.  If the existing OpenAI instance is not in the same subscription as where you're deploying your resources, you will need to update the following (using whatever models and version you deployed in OpenAI Studio):

| AZURE_OPENAI_CHATGPT_MODEL_NAME        | gpt-35-turbo                                       |
| AZURE_OPENAI_CHATGPT_MODEL_VERSION     | 0301                                               |
| AZURE_OPENAI_EMBEDDINGS_MODEL_NAME     | text-embedding-ada-002                             |
| AZURE_OPENAI_EMBEDDINGS_MODEL_VERSION  | 2                                                  |

19.  Save the file.
20.  If you're deploying to Azure Government, run the following command in the console (open console with Terminal > New Terminal):
az cloud set --name AzureUSGovernment
21.  Now you need to authenticate and ensure you're targeting the correct subscription and tenant.  Use the following commands in the terminal to authenticate and set the correct target subscription (the same one you added to the local.env file) for your deployment and then confirm it:

```css
az login --use-device-code
az account list
az account set --subscription {your target subscription id}
az account show
```

22.  Deploy your resources by running the following command:

```
make deploy
```

23.  Watch for a prompt.  It should take about 1 &half; minutes.
24.  When prompted with "Are you happy with the plan? Would you like to apply?" type y and then press enter.
25.  Wait for the deployment to complete successfully.  (up to 31 minutes)
26.  In the Azure portal, navigate to the resource group you're deploying to and note the five-character generated string appended to most of the resource names.
27.  In the Azure portal, navigate to the infoasst_web_access_xxxxx enterprise application in Microsoft Entre ID (where 'xxxxx' is the same generated suffix used for your resources).
   - Note:  You may need to delete the filter to only show Application type of "Enterprise Application".
28.  Open the enterprise application, then go to Manage > Users and Groups
29.  Add yourself as a user.
30.  If you want to make your application accessible to anyone in your directory (tenant):
   - Go to Manage > Properties
   - Change "Assignment Required?" to "No" if it isn't already.  If it's set to "Yes" then only the users/groups you added in the previous step will have access.
31.  Navigate to the infoasst-web-xxxx Web App resource in the portal, and click on the URL for the website.
   - If permissions are requested, accept.
   - If the website reports an Application Error, check your env file, fix any errors, and run make deploy again.
   - If the website reports a redirect URL mismatch, check the redirect URI in the infoasst_web_access_xxxxx app registration and ensure you changed .net to .us
   - To aid in troubleshooting, you can navigate to the logstream using KUDU (scm) at:  https://infoasst-web-xxxxx.scm.azurewebsites.us/api/logstream
   - Note that Application Insights may not be helpful, if the web application is not compatible.

# Demonstrations

- Make a query, but ask for it in another language.
- Make a query, but ask for it in another language and font.
- Tell a joke about the grounded data.

# Other Information

There are 16 primitive Pythagorean triples of numbers up to 100:

(3, 4, 5)	(5, 12, 13)	(8, 15, 17)	(7, 24, 25)
(20, 21, 29)	(12, 35, 37)	(9, 40, 41)	(28, 45, 53)
(11, 60, 61)	(16, 63, 65)	(33, 56, 65)	(48, 55, 73)
(13, 84, 85)	(36, 77, 85)	(39, 80, 89)	(65, 72, 97)
