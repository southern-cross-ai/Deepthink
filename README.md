# 🌟 DeepThink - Guild AI Team

<div align="center">
  <img src="https://i.imgur.com/GZ7rUqN.gif" width="400"/>
</div>  

## 🎯 Our Mission

DeepThink is an AI-driven research team under **Guild AI**, dedicated to exploring innovative ways of integrating **Large Language Models (LLMs)** into **Unreal Engine 5**. Our primary objective is to streamline the interaction between **ChatGPT API** and **Unreal Engine**, enabling seamless AI-powered content creation.

<div align="center">
  <img src="https://media.giphy.com/media/QTfX9Ejfra3ZmNxh6B/giphy.gif" width="400"/>
</div>


---

## 🔍 Key Objectives

### 🏗️ **Building an Unreal Plugin for LLM Integration**
- Investigate the most effective approach to integrating **ChatGPT API calls** into Unreal as a **plugin**.
- Leverage **existing tools and frameworks** to maximize efficiency and minimize redundant efforts.
- Establish a **baseline** by identifying the best practices currently available.

---

### 🎮 **Expanding AI-Driven Content Authoring**
- **Placing assets dynamically**: Use LLM APIs to automatically position and configure assets in Unreal scenes.
- **Procedural content generation**: Utilize AI to assist the content team in generating:
  - 📜 New missions and quest lines.
  - 🎭 Story-driven NPC dialogues.
  - 🎁 New items, world objects, and interactive components.
- **Optimizing AI-assisted workflows** for more immersive world-building inside Unreal Engine.

---

## 🏗 Implementation Plan

### ✅ Step 1: Setting Up Python for Unreal Engine
To enable Unreal Engine to interact with Python, we first need to ensure that **Python scripting is supported** within the engine. This can be achieved using **Epic’s built-in Python Editor Script Plugin** or opting for the **community-driven UnrealEnginePython plugin**. Once enabled, we will develop **simple scripts that interact with Unreal assets**, ensuring that we can **read, modify, and manipulate** game objects via Python commands.

### ✅ Step 2: Establishing a Connection with ChatGPT
Before integrating ChatGPT into Unreal, we will first create a **standalone Python script** that can communicate with the **OpenAI API**. Using the **openai library**, we will authenticate with the service, send **test prompts**, and validate the responses. This will serve as the foundation for all AI-driven interactions within Unreal.

### ✅ Step 3: Integrating ChatGPT into Unreal Engine
Once we have a functioning API connection, the next step is embedding this capability into **Python scripts that Unreal Engine can execute**. This involves creating scripts that **retrieve context from Unreal assets**, generate AI-driven content via ChatGPT, and **seamlessly inject** the results back into Unreal’s properties. For example, we could develop a script like **"GenerateNPCDialogue.py"**, where AI-generated dialogue dynamically populates an NPC’s text field.

### ✅ Step 4: Developing an Editor Utility Widget
Depending on the project's progress and requirements, we may explore the development of a **custom Editor Utility Widget** to enhance usability. This widget could provide an intuitive interface for triggering AI interactions inside Unreal. However, its necessity will depend on how effectively other methods integrate ChatGPT into the workflow. Potential features of the widget might include:
- A **text input field** for specifying styles or context for AI-generated content.
- A **Generate button** to call ChatGPT and retrieve relevant data.
- A **real-time preview window** to display AI-generated results immediately.

### ✅ Step 5: Expanding Capabilities & Optimizing Performance
Once the basic system is in place, we will refine it by:
- **Improving prompt structuring** to yield more relevant and high-quality AI responses.
- **Implementing iterative content generation**, allowing for back-and-forth refinement of AI-generated assets.
- **Integrating with Unreal Blueprints**, so AI-driven content can dynamically interact with in-game mechanics.
- **Optimizing performance and monitoring API usage** to ensure smooth execution without excessive costs.

### 🚀 **Laying the Foundation for Future Development**
- Identify **long-term technical requirements** for LLM integration beyond the current project scope.
- Provide **comprehensive documentation** and **clear development guidelines** to enable future teams to build upon our work.
- Establish a **scalable framework** to support **next-gen AI content generation** inside Unreal.

## 🌍 Why It Matters
By bridging the gap between **LLMs and game development**, DeepThink aims to revolutionize how interactive content is created. Our research will **empower designers, developers, and storytellers** to bring new levels of dynamic AI-driven creativity into Unreal Engine 5. 

🚀 *Join us as we shape the future of AI-assisted game development!* 🎮

---

## 👥 Team Members
| Name | Role | Email |
|------|------|-------|
| XiangyuTan | Team member | u7779491@anu.edu.au |
| Diming Xu | Team member | u7705332@anu.edu.au |
| [Member 3] | [Role] | [Email] |
| [Member 4] | [Role] | [Email] |
| [Member 5] | [Role] | [Email] |
| [Member 6] | [Role] | [Email] |
