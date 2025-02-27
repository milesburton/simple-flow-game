# AI Food Finding Game

A simple web-based game where two AIs compete to find and eat food items. As they eat, they grow larger, similar to the game "Grow".

## Features

- Canvas-based visualization
- Configurable AI strategies
- Growth mechanics
- Auto-reset when AIs reach maximum size
- Easily deployable to Netlify

## Getting Started

### Development with DevContainer

This project is configured to work with Visual Studio Code's DevContainer feature.

1. Make sure you have [Docker](https://www.docker.com/products/docker-desktop) installed
2. Install the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension in VS Code
3. Clone this repository
4. Open the project in VS Code
5. When prompted, click "Reopen in Container" or use the command palette (F1) and select "Remote-Containers: Reopen in Container"
6. Once the container is built and running, open a terminal in VS Code and run:
   ```
   npm start
   ```
7. Open your browser to http://localhost:3000

### Without DevContainer

If you prefer not to use DevContainer:

1. Make sure you have Node.js installed (v14+)
2. Clone this repository
3. Run `npm install`
4. Run `npm start`
5. Open your browser to http://localhost:3000

## Deploying to Netlify

This project is ready to deploy to Netlify:

1. Push your code to a GitHub repository
2. Log in to [Netlify](https://www.netlify.com/)
3. Click "New site from Git"
4. Select your repository
5. Keep the default settings (build command should be empty, publish directory should be ".")
6. Click "Deploy site"

## Game Controls

- **Start Game**: Begins the simulation
- **Pause**: Pauses the current game
- **Reset**: Resets the game state

## AI Strategies

You can configure each AI with different strategies:

- **Random**: AI randomly selects food targets
- **Nearest**: AI always goes for the closest food item (default)
- **Greedy**: AI considers both distance and value of food

## Customization

You can modify various game parameters in the `config` object in the JavaScript code:

- Food count
- Growth rate
- Maximum AI size
- AI speed
- Food generation rate

## Future Enhancements

- Add more sophisticated AI strategies
- Implement obstacles or walls
- Add competitive elements between AIs
- Create larger game areas as AIs grow
