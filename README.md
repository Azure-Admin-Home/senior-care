# Senior Case

## Versioning

### Naming Conventions: Branch, PR, Commits, etc

#### Branch

Use `Git Flow` to develop.

Name branches as follows:

```text
feature/<firstname-firstletter-and-complete-lastname>/<issue-number>-<brief-description>
```

Eg. `feature/lightning-listener/666-onload-delay`

#### Pull Requests

As in branch naming convention, contextualize Pull Requests (PR) names. Use camel cases and punctuation accordingly.

```text
#666 [<FEATURE CATEGORY NAME>] Brief description
```

Eg. `#666 [FE][BE] The number of the beast`

Mind the values in between, eg. `[EXAMPLE]`

- `BACKEND` or `BE`
- `BUG`
- `CHECKOUT`
- `CI`
- `FEATURE`
- `FRONTEND` or `FE`
- `HOTFIX` or `FIX`
- `RELEASE`
- `SETUP`
- `TASK`
- `TOOLS`
<!-- - `RETURNS` -->
<!-- - `BLOG` -->
<!-- - `JOBS` -->
<!-- - `MYACCOUNT` -->
<!-- - `PDP` -->
<!-- - `SEARCH` -->

Pull Requests (PR) should contain at least:

- A brief description of the effect that the code changes are going to introduce
- A list which enumerates through a detailed checklist all the improvements and todos
- Resources (Work Items)

PR opened in order to solve an issue should mention the issue they are related to and state if the merge will resolve the issue (eg. `Fixes #666` or `Resolves #666`). Put the code issue number on the first commit description.

#### Commits

Dunno how to commit? Read the holy bible [http://chris.beams.io/posts/git-commit/](http://chris.beams.io/posts/git-commit/) and follow the path that leads to the Holy Grail!

![](https://imgs.xkcd.com/comics/git_commit_2x.png)

## Environment Configuration

### Install

Check the guide [Getting Started with Visual Studio Code for Salesforce Developers](https://forcedotcom.github.io/salesforcedx-vscode/articles/getting-started/install)

1. Install latest version of [Visual Studio Code](https://code.visualstudio.com/Download)
2. Install [Salesforce Extensions for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=salesforce.salesforcedx-vscode)
3. Clone the repo
```
git clone https://github.com/Azure-Admin-Home/senior-care.git
```
4. (Optional) After cloning the repo reopen project with Visual Studio Code (Important to launch SFDX)
5. In Command Palette(<kbd>CMD</kbd> + <kbd>SHIFT</kbd> + <kbd>P</kbd>) **SFDX: Authorize an Org**\
![](https://res.cloudinary.com/dla5os8qp/image/upload/v1560937567/sfdx/auth_org_zvggqu.png =450x)
6. Select the Org type\
![](https://res.cloudinary.com/dla5os8qp/image/upload/v1560937567/sfdx/org_type_m1zmuc.png =450x)
7. Put the Org name to save the connection\
![](https://res.cloudinary.com/dla5os8qp/image/upload/v1560937567/sfdx/org_name_noczae.png =450x)

### Project Configuration

Use `.vscode/settings.json` file to config VSCode for the local project. Recommended settings:

```json
  "salesforcedx-vscode-core.push-or-deploy-on-save.enabled": true,
  "search.exclude": {
    "**/node_modules": true,
    "**/bower_components": true,
    "**/.sfdx": true,
    "**/*meta.xml": true
  },
  "search.useIgnoreFiles": false
```

### Project structure

    .
    ├── sfdx-preject.json       # SFDX Project Settings
    ├── manifest                # Package Structure Directory
    |   └── package.xml         # Metadata Types Description for Retrieve from Org
    ├── force-app               # Default Package Directory (Use only for retrieve metadata)
    └── src                     # Main Package Directory (Use to work with metadata)

### Retrieve data from org

Use **SFDX: Retrieve Source in Manifest to Org**\
![alt text](https://res.cloudinary.com/dla5os8qp/image/upload/v1560937572/sfdx/retrieve_data_q7ro1y.png =450x)

### Code

If some task cannot be completed, put the comment on the file.

There are 4 types of comment:

- `//TODO: Lorem` used for labels that are not yet translated
- `//TODO: Href` used for links that are not yet the finals
- `//TODO: missing some informations ` used for general missing develops
- `//FIXME: [FE/BE] …` used for broken parts of code that need to be fixed