# GitHub-Tooling-for-Agile-Template-Repository
This is a template repository to be used as the base for all new repos created for the [GitHub Tooling for Agile](https://potential-adventure-k5kp3j1.pages.github.io) training course (by a course facilitator). It comes with a set of default issues, types, directory structure, [a template markdown file](./recipes/recipe_template.md), and settings to ensure a standardised setup. 

# Set Up
The following steps will need to be performed immediately after creating the new repository to complete the set up.

## Define and Link a Project
Defining and linking a Project to this repository should be performed as part of the initial setup on the course. Learners should be instructed to use the [Agile Methods Training template project](https://github.com/orgs/UoMResearchIT/projects/270/views/1) to set this up.

## Alter this README!
This README should be changed by the course facilitator to leave any instructions (e.g. the above section on defining and linking a project) that are part of the course learning, and other elements should be deleted before passing the repository on to the learners.

## Copy Issues 
In order to streamline the learning in the requirements gathering chapter, some issues relating to the product have already been created in the template repository.  To copy these issues from the template into the new repository that the learners are going to use, please run the copy-issues workflow from the Actions tab in the new repository. Once this workflow has run successfully and you have all the initial issues copied in, you can then safely delete the workflow (`.github/workflows/copy-issues.yml`) and scripts (`load_isses.sh`, `save_issues.sh`) used to perform this workflow, before passing the repository to the learners.

