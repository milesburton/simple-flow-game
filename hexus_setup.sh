#!/bin/bash

# Constants
PROJECT_NAME="hexus-forum-scraper"
SCRAPER_FILE="src/scraper/test_scraper.ts"
DATABASE_FILE="data/forum_data.db"

# Functions
emoji_success() {
  echo -e "\e[32m✅ $1\e[0m"
}

emoji_warn() {
  echo -e "\e[33m⚠️ $1\e[0m"
}

emoji_error() {
  echo -e "\e[31m❌ $1\e[0m"
}

emoji_info() {
  echo -e "\e[34mℹ️ $1\e[0m"
}

check_directory() {
  if [ -d "$PROJECT_NAME" ]; then
    emoji_warn "Project directory '$PROJECT_NAME' already exists."
    read -p "Do you want to delete and recreate it? (y/n): " answer
    if [[ "$answer" == "y" ]]; then
      emoji_info "Deleting existing project directory..."
      rm -rf "$PROJECT_NAME"
    else
      emoji_error "Aborting setup. Please remove the existing directory or choose a different project name."
      exit 1
    fi
  fi
}

create_directories() {
  mkdir -p "$PROJECT_NAME"
  cd "$PROJECT_NAME"
  mkdir -p src/scraper data
  emoji_success "Created project directories."
}

init_git() {
  git init
  git config --global core.autocrlf false # Ensure consistent line endings (LF)
  emoji_success "Initialized Git repository."
}

create_bun_project() {
  bun init -y
  emoji_success "Initialized Bun project."
}

create_env_file() {
  cat <<EOF > .env
# Replace with the actual URL of the forum
FORUM_URL="https://forums.hexus.net/"
DATABASE_PATH="data/$DATABASE_FILE"
EOF
  emoji_success "Created .env file."
}

create_scraper_file() {
  cat <<EOF > "$SCRAPER_FILE"
import * as cheerio from 'cheerio';
import { createClient } from '@libsql/client';
import * as dotenv from 'dotenv';

dotenv.config(); // Load environment variables from .env file

const FORUM_URL = process.env.FORUM_URL;
const DATABASE_PATH = process.env.DATABASE_PATH;

async function scrapeTest() {
  try {
    const response = await fetch(FORUM_URL, {
      headers: { 'User-Agent': 'Mozilla/5.0 (Your Browser)' },
    });
    if (!response.ok) {
      throw new Error(\`HTTP error! status: \${response.status}\`);
    }
    const html = await response.text();

    const \$ = cheerio.load(html);
    const forumTitle = \$('title').text().trim();

    //Connect to database
    if (!DATABASE_PATH) {
      throw new Error("DATABASE_PATH is not defined in .env file");
    }

    const db = createClient({ url: 'file:\${DATABASE_PATH}' });
    await db.execute(\`
      CREATE TABLE IF NOT EXISTS test_data (
        title TEXT
      )
    \`);
    await db.execute({
      sql: 'INSERT INTO test_data (title) VALUES (?)',
      args: [forumTitle],
    });

    console.log(\`Successfully scraped title: \${forumTitle} and saved to database!\`);

  } catch (error) {
    console.error("Error during scraping:", error);
  }
}

scrapeTest();
EOF
  emoji_success "Created scraper file: $SCRAPER_FILE"
}

create_sqlite_file() {
  touch "$DATABASE_FILE"
  emoji_success "Created SQLite database file: $DATABASE_FILE"
}

create_gitignore_file() {
  cat <<EOF > .gitignore
node_modules/
data/*.db
.DS_Store
.env
dist/
.bun/
EOF
  emoji_success "Created .gitignore file."
}

create_readme_file() {
  cat <<EOF > README.md
# $PROJECT_NAME

A scraper for the Hexus Forums using Bun and TypeScript.

## Setup

1.  Clone the repository. **Make sure the project is in your WSL2 file system (e.g., /home/<your_username>/).**
2.  Install Docker and VS Code with the Remote - Containers extension.
3.  Open the project in VS Code.
4.  The devcontainer will automatically build and launch.

## Usage

1.  Install dependencies: \`bun install\`
2.  Run the scraper: \`bun run $SCRAPER_FILE\` (or use \`tsx\` or similar to run directly)

## License

MIT License. See LICENSE file for details.
EOF
  emoji_success "Created README.md file."
}

create_license_file() {
  cat <<EOF > LICENSE
MIT License

Copyright (c) $(date +%Y) [Your Name]

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
EOF
  emoji_success "Created LICENSE file."
}

create_devcontainer_files() {
  mkdir -p .devcontainer
  cat <<EOF > .devcontainer/devcontainer.json
{
    "name": "Hexus Forum Scraper Dev Container",
    "build": {
        "dockerfile": "../Dockerfile"
    },
    "customizations": {
        "vscode": {
            "settings": {
                "terminal.integrated.shell.linux": "/bin/bash",
                "typescript.tsdk": "/usr/local/lib/node_modules/typescript/lib",
                "editor.formatOnSave": true,
                "files.eol": "\n",
                "editor.defaultFormatter": "esbenp.prettier-vscode",
                "eslint.validate": [
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact"
                ],
                "files.insertFinalNewline": true,
                "files.trimTrailingWhitespace": true
            },
            "extensions": [
                "dbaeumer.vscode-eslint",
                "esbenp.prettier-vscode",
                "ms-azuretools.vscode-docker",
                "eamodio.gitlens",
                "christian-kohler.npm-intellisense"
            ]
        }
    },
    "postCreateCommand": "bun install",
    "remoteUser": "vscode"
}
EOF

  cat <<EOF > Dockerfile
# Use the official Bun image as the base image
FROM oven/bun:latest

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and bun.lockb to the working directory
COPY package.json bun.lockb ./

# Install dependencies using bun install
RUN bun install

# Copy the rest of the application code to the working directory
COPY . .

# Define the command to run when the container starts
CMD ["bun", "run", "$SCRAPER_FILE"]
EOF
  emoji_success "Created .devcontainer files."
}

# Main Script
check_directory
create_directories
init_git
create_bun_project
create_env_file
create_scraper_file
create_sqlite_file
create_gitignore_file
create_readme_file
create_license_file
create_devcontainer_files

emoji_success "Project '$PROJECT_NAME' created successfully!"
emoji_info "Next steps:"
emoji_info "**Important: Ensure the project is in your WSL2 file system!**"
emoji_info "1. Open the project in VS Code."
emoji_info "2. VS Code will prompt you to reopen in the devcontainer."
emoji_info "3. Run 'bun install' to install dependencies."
emoji_info "4. Run 'bun run $SCRAPER_FILE' to test the scraper."
emoji_info "5. Commit and push to GitHub."