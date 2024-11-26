# 3D Avatar Generator and Customization Platform

A full-stack web application that generates personalized 3D avatars using conditional Generative Adversarial Networks (cGAN) and allows users to customize their avatars with clothing, hair, and other features.
## 3D Personalized Avatar Customization Interface Demo
Here is an image of the customization interface for the 3D personalized avatar, which corresponds to 15 personalized body measurements and includes virtual try-on features. 
  ![image](https://github.com/user-attachments/assets/4f76e763-717f-4356-9faa-28c6e495fedd)
## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Technical Architecture](#technical-architecture)
- [Installation](#installation)
- [Project Structure](#project-structure)
- [How It Works](#how-it-works)
- [API Documentation](#api-documentation)
- [Technologies Used](#technologies-used)

## Overview

This platform allows users to generate personalized 3D avatars by inputting their body measurements. The system uses a conditional GAN to create accurate 3D point clouds which are then converted into meshes. Users can customize their avatars with various clothing items, hairstyles, and other features through an interactive 3D interface.

## Features

- **User Authentication**
  - Secure login/signup system
  - Session management
  - Password encryption

- **Avatar Generation**
  - Body measurement input form
  - Real-time 3D avatar generation using cGAN
  - Point cloud to mesh conversion

- **Avatar Customization**
  - Multiple clothing options (dresses, skirts, sweaters)
  - Various hairstyles
  - Skin color selection
  - Size customization for clothing
  - Color options for clothing items

- **Interactive 3D Viewer**
  - Real-time 3D rendering
  - Orbit controls for view manipulation
  - Dynamic lighting system

- **Multilingual Support**
  - English and French interfaces
  - Dynamic language switching

## Technical Architecture

### Backend (Flask)
- **Authentication Module** (`app/routes/auth.py`)
  - Handles user registration and login
  - Session management using Flask-Login

- **Avatar Generation** (`app/utils/avatar_processing.py`)
  - cGAN implementation for point cloud generation
  - Point cloud processing and mesh conversion
  - Uses PyTorch for neural network operations

- **Clothing System** (`app/routes/clothing.py`)
  - Manages clothing model loading and customization
  - Handles size and color modifications

### Frontend
- **3D Rendering** (Three.js)
  - Real-time mesh visualization
  - Dynamic model loading and manipulation
  - Custom shader implementations

- **UI Components** (`static/js/`)
  - Modular JavaScript architecture
  - Event handling for customization options
  - Responsive design implementation



## Avatar Generation Process

The avatar generation uses a conditional GAN architecture:

1. **Generator Network**
- Takes body measurements as input (15 dimensions)
- Progressively expands features through multiple layers
- Outputs a point cloud of 10,000 3D points
- Uses GroupNorm and SiLU activation for stability

2. **Discriminator Network**
- Processes both point clouds and measurements
- Parallel feature extraction paths
- Combines features for final discrimination
- Outputs real/fake probability

3. **Training Process**

   
## Installation

1. Clone the repository:
   https://github.com/Aideveloper-dev/IEEE_challenge.git  
2. Install dependencies:
   pip install -r requirements.txt 
3. Set up the database:
   flask db upgrade
4. Run the application:
   python run.py


## API Documentation

### Authentication Endpoints
- `POST /login` - User login
- `POST /signup` - User registration
- `GET /logout` - User logout

### Avatar Endpoints
- `POST /generate` - Generate new avatar
- `POST /update_cloth` - Update clothing
- `POST /update_feature` - Update avatar features

## Technologies Used

### Backend
- Flask
- PyTorch
- Open3D
- SQLAlchemy
- NumPy
- SciPy

### Frontend
- Three.js
- JavaScript (ES6+)
- HTML5
- CSS3
- WebGL

### Database
- SQLite

### Development Tools
- Flask-Compress
- Flask-Login
- Werkzeug

### Directory Details

#### `/app`
- Core application logic and routing
- Organized into modules for better maintainability

#### `/app/routes`
- **auth.py**: Handles user authentication
  - Login/logout functionality
  - User registration
  - Session management
- **avatar.py**: Manages avatar generation
  - Measurement processing
  - 3D model generation
  - Avatar customization endpoints
- **clothing.py**: Controls clothing system
  - Clothing model loading
  - Size and color management

#### `/app/utils`
- **avatar_processing.py**: Core avatar generation logic
  - Point cloud processing
  - Mesh generation
  - Avatar optimization
- **model_loader.py**: ML model management
  - Model loading utilities
  - Inference optimization
  - GPU management

#### `/app/models`
- **user.py**: Database schema
  - User information
  - Authentication data
  - Profile settings

#### `/static`
- Client-side assets and resources
- Organized by type (JS, CSS, 3D models)

#### `/static/js`
- Modular JavaScript architecture
- Separate concerns for maintainability
- Client-side processing and UI logic

#### `/static/css`
- Styled components and layouts
- Responsive design implementation
- Theme management

#### `/static/models`
- 3D asset storage
- Organized by category
- Optimized for web delivery

#### `/templates`
- Jinja2 HTML templates
- Page layouts and structure
- Dynamic content integration

#### `config.py`
- Application settings
- Environment configurations
- Database connections
- Security parameters

### Key Features by Directory

1. **Authentication (`/app/routes/auth.py`)**
   - Secure login system
   - Password hashing
   - Session management

2. **Avatar Generation (`/app/routes/avatar.py`)**
   - Measurement processing
   - 3D model generation
   - Customization endpoints

3. **Clothing System (`/app/routes/clothing.py`)**
   - Model loading
   - Size management
   - Color customization

4. **Frontend (`/static/js/`)**
   - 3D rendering
   - User interface
   - Real-time updates

5. **Styling (`/static/css/`)**
   - Responsive design
   - Theme management
   - Component styling

6. **Templates (`/templates/`)**
   - Page structure
   - Dynamic content
   - User interface layout

### Development Guidelines

1. **Route Management**
   - Keep routes modular and focused
   - Use blueprints for organization
   - Maintain consistent error handling

2. **Static Assets**
   - Optimize for performance
   - Use appropriate compression
   - Implement caching strategies

3. **Templates**
   - Follow DRY principles
   - Use template inheritance
   - Maintain consistent structure

4. **Configuration**
   - Use environment variables
   - Separate development/production configs
   - Secure sensitive information



