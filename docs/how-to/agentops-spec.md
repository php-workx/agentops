Agent OS is a free, open-source system designed for spec-driven development, allowing AI coding agents to follow your specific patterns, architectural decisions, and coding style rather than just generic best practices. Agent OS is structured around **three layers of context**: Standards, Product, and Specs.

Below is a step-by-step transcript detailing the installation and usage of Agent OS, drawing directly from the source material.

---

## Part 1: Installing Agent OS

Installation involves a two-part system: the **Base Installation** (where standards are defined) and the **Project Installation** (where standards are copied into a specific codebase).

### A. Base Installation (System Setup)

The base installation serves as your source files for every project installation and is typically recommended to be installed in your home directory.

| Step | Action | Details & Source Citation |
| :--- | :--- | :--- |
| **1. Access Documentation** | Navigate to the Agent OS documentation page. | Go to `buildermethods.com/agentos` to find the documentation and guides, including installation instructions. |
| **2. Choose Location** | Decide where on your system to install the base files. | The home folder is typically recommended, though it doesn't have to be there. |
| **3. Select Script** | Choose the base installation script that matches your tools. | There are different scripts depending on whether you are using Cloud Code support, Cursor support, or both. Cloud Code and Cursor have official support, but Agent OS is adaptable to other coding agent tools. |
| **4. Run Installation Command** | Copy the script command and paste it into your terminal. | Navigate to your chosen directory (e.g., the home folder) and run the command. This script pulls the base installation files directly from the public GitHub. |
| **5. Review Next Steps** | Note the personalized project installation command. | The install script will provide a few next steps, including the personalized command needed later for project installation. It is recommended to bookmark this or create a terminal alias for it. |
| **6. Customize Standards (Crucial)** | Define your specific development rules and best practices. | Navigate to the new `agent OS` folder created by the installation. Customize the files inside the `standards` folder, which include `default text stack`, `code style`, and `best practices`. **This step is crucial** because Agent OS needs to be taught your specific patterns, architectural decisions, and coding style. The `code style` folder allows for specific notes related to languages like CSS or HTML. |
| **7. Configure Agents (Optional)** | Check the configuration file. | The base installation includes a `config` file where you can enable support for coding agents (like Cloud Code or Cursor) and define project types. |

### B. Project Installation (Adding to a Project)

This step installs the customized standards into a new or existing project.

| Step | Action | Details & Source Citation |
| :--- | :--- | :--- |
| **1. Navigate to Project** | Open your project and navigate to its directory in the terminal. | Agent OS can be installed into any project, including those already midway through development. |
| **2. Run Setup Project Command** | Execute the project installation command. | Call the `setup_project.sh` file from where it lives on your system (e.g., `~/agentos/setup_project.sh`). If you forewent the base installation, you can install directly from GitHub, but you would then need to make customizations directly in the project. |
| **3. Verify Project Structure** | Confirm the self-contained installation. | A new `agent OS` folder is created inside your project directory, containing copies of your customized `instructions` and `standards`. This installation is self-contained, can be committed into Git, and shared with team members. |
| **4. Agent Readiness** | Note the available commands. | The project installation also brings in sub-agents and commands for Cloud Code, and creates corresponding rules in the Cursor folder for Cursor users. These commands reference the instructions inside the project's Agent OS folder, making the instructions available to both Claude and Cursor. |

---

## Part 2: Using Agent OS (The Spec-Driven Cycle)

The primary workflow involves three main commands used sequentially: `plan product` (or `analyze product`), `create spec`, `create tasks`, and `execute tasks`.

### A. Phase 1: Establish Product Context

This phase defines what you are building and why—your mission, roadmap, users, and use cases.

| Step | Action | Details & Source Citation |
| :--- | :--- | :--- |
| **1. Run Product Planning** | Use the appropriate command for your project status. | Use the **`plan product`** command if starting a new product from the ground up. Use the **`analyze product`** command if installing Agent OS into an existing, midway project. |
| **2. Answer Prompts** | Provide details to the agent. | The agent will ask questions about the main idea, key features, target users and their use cases, and tech stack preferences. The Context Fetcher sub-agent will read your standards and preferences to build the plan. |
| **3. Review Product Files** | Check the generated documentation. | The agent creates a `product` folder containing: **`mission.md`** (the product pitch, core problems, and solutions), **`mission_light.md`** (a shorter, context-efficient version), and **`roadmap.md`** (a high-level plan outlining the sequence of features). |
| **4. Update Roadmap** | Edit the roadmap to reflect current progress. | Review the `roadmap.md` to ensure it aligns with your expectations. Agent OS will check this road map when suggesting the next task, so you should add an 'X' next to features already completed. |

### B. Phase 2: Create the Specification (Spec)

This phase plans out an entire feature implementation, leaving no detail or decision to chance.

| Step | Action | Details & Source Citation |
| :--- | :--- | :--- |
| **1. Run Spec Creation** | Start planning the next feature. | Use the **`create spec`** command. |
| **2. Review Suggestion** | Confirm the feature choice. | The Context Fetcher sub-agent checks the roadmap to suggest the next feature. You can accept the suggestion or deviate from the road map by providing raw instructions for a new feature. |
| **3. Clarify Requirements** | Answer any clarifying questions from the agent. | The agent will ask questions to ensure total alignment on the project, particularly regarding infrastructure, pre-established views, layouts, and styling. You can refine these common conventions and put them into your Standards over time. |
| **4. Review the Spec** | Check the detailed implementation plan. | The agent creates a dated folder for the feature in `agent OS/specs`. This folder contains the main spec, user stories, technical specification, and database schema (if applicable). **This is the power of spec-driven development:** as the product designer, engineer, or architect, you must review every line of the specs to ensure they are carefully crafted and aligned to your vision before allowing the agent to build. |

### C. Phase 3: Create and Execute Tasks

Once the spec is finalized, the agent converts it into an actionable list and begins coding.

| Step | Action | Details & Source Citation |
| :--- | :--- | :--- |
| **1. Run Task Creation** | Generate the task list from the approved spec. | Run the **`create tasks`** command. |
| **2. Review Tasks** | Check the order of implementation. | The spec is broken down into a list of tasks and subtasks. Agent OS follows a test-driven development approach, usually starting each task with writing the test. Review the order of implementation line by line. |
| **3. Execute Tasks** | Start the implementation process. | Run the **`execute tasks`** command, specifying which tasks to implement (e.g., `execute tasks number one` or `execute tasks all five tasks`). |
| **4. Agent Workflow** | The agent performs the coding autonomously. | The agent gathers context (mission, code style, best practices), uses the Git Workflow sub-agent to change to a feature branch, runs migrations, writes tests, sets up views, and uses the Test Runner sub-agent to verify that all tests pass. |
| **5. Post-Implementation** | Review automatic documentation updates. | Once implementation is complete, the Project Manager sub-agent verifies completion, creates a descriptive commit message, automatically updates the `roadmap.md` by checking off the feature, and writes a short recap document in the `recaps` folder. These recaps are useful for context transfer if switching between different agents (like Cloud Code and Cursor). |

### D. Phase 4: Review and Polish

The final stage ensures the feature meets quality standards.

| Step | Action | Details & Source Citation |
| :--- | :--- | :--- |
| **1. Test in Browser** | Verify the implemented feature. | The agent provides instructions on what is ready to test. |
| **2. Apply Polish** | Clean up minor fixes and tweaks. | It is a normal part of the process that the agent may not get the implementation 100% perfect, especially regarding UI/UX polish. The user often needs to come in and make minor fixes and tweaks to reach the finish line. |
| **3. Inspect Code** | Review the generated code and test suite. | Check all the code written by the agent and confirm the written tests are passing. |

---
**Analogy:** Using Agent OS is like handing your junior developer (the AI agent) a detailed, meticulously reviewed construction blueprint (the Spec) and a site checklist (the Task List) for a house. Instead of telling them, "Build me a kitchen," you tell them exactly *how* you build kitchens (Standards), *why* this house needs a kitchen (Product Context), and precisely what materials and steps to follow, ensuring the resulting structure matches your architectural style every single time.
