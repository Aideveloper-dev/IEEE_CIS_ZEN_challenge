# 3D Avatar Generator and Customization Platform (Zen/CIS-IEEE challenge )

A full-stack web application that generates personalized 3D avatars using conditional Generative Adversarial Networks (cGAN) and allows users to customize their avatars with clothing, hair, and other features.
## 3D Personalized Avatar Customization Interface Demo
Here is an image of the customization interface for the 3D personalized avatar, which corresponds to 15 personalized body measurements and includes virtual try-on features. 
  ![image](https://github.com/user-attachments/assets/4f76e763-717f-4356-9faa-28c6e495fedd)
## Table of Contents
- [Overview](#overview)
- [Features](#features)
- [Technical Architecture](#technical-architecture)
- [AI Component of the Project: Avatar Generation Using Generative AI](#ai-component-of-the-project:avatar-generation-using-generative-ai)
- [Installation](#installation)
- [API Documentation](#api-documentation)
- [Technologies Used](#technologies-used)
- [Directory Details](#directory-details)

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



## AI Component of the Project: Avatar Generation Using Generative AI

### Overview of Generative AI
Generative AI is a subset of artificial intelligence that creates new content, such as images, text, or 3D objects. Unlike traditional AI models, which classify or predict based on input data, generative models learn the underlying patterns in data and use that understanding to generate entirely new outputs. This project leverages **Generative Adversarial Networks (GANs)** to create realistic 3D avatars tailored to individual body measurements.


### Deep Learning and GAN Models

#### GAN Architecture

GANs are composed of two neural networks:
- **Generator:** Creates new data (3D avatars) from input measurements.
- **Discriminator:** Distinguishes between real (ground truth) and fake (generated) data, providing feedback to improve the generator's output.

The generator and discriminator compete in a **min-max game**, iteratively improving until the generator produces outputs indistinguishable from real data.



### Avatar Generation Process

#### Conditional GAN (cGAN) Architecture

This project uses a **Conditional GAN (cGAN)**, where the generator and discriminator are conditioned on input data (15 personalized body measurements). Conditioning ensures that the outputs correspond closely to the given measurements.



#### Generator Network

- **Input:** 15 body measurements (e.g., neck girth, waist girth, thigh girth).
- **Process:**
  - Expands input features through multiple fully connected layers.
  - Applies **Group Normalization (GroupNorm)** for stability and convergence.
  - Uses **SiLU** activation functions for improved non-linearity.
- **Output:** A 3D point cloud with 10,000 points representing the avatar's shape.
- **Final Activation:** **Tanh** to normalize the output values between -1 and 1.



#### Discriminator Network

- **Input:** Both real/generated 3D point clouds and the corresponding body measurements.
- **Process:**
  - Extracts features from the 3D point clouds and measurements in parallel paths.
  - Combines these features for a final classification.
  - Uses **Batch Normalization (BatchNorm)** and **LeakyReLU** activation for robust training.
- **Output:** A probability score indicating whether the input point cloud is real or fake.



### Training Process

1. **Discriminator Training:**
   - Evaluates real point clouds paired with real measurements (high "real" probabilities).
   - Evaluates generated point clouds paired with real measurements (low "real" probabilities).
   - Uses **Binary Cross-Entropy Loss (BCE)** for loss calculation.

2. **Generator Training:**
   - Takes body measurements as input to generate a 3D point cloud.
   - Evaluates generated point clouds using the discriminator (aiming for high "real" probabilities).
   - Includes **Chamfer Distance Loss** to measure similarity between generated and real point clouds.
   - Combines **BCE Loss** and **Chamfer Distance** for the total generator loss.



### Dataset and Preprocessing

#### Input Data

- **CSV File:** Contains 15 body measurements per subject.
- **3D Avatar Files:** Corresponding `.obj` files representing ground truth data.

#### Data Pipeline

1. **Normalization:** Measurements are scaled and normalized for input into the generator.
2. **Point Cloud Conversion:** `.obj` files are parsed into point clouds using **PyTorch3D** for real-data comparison.
3. **Padding:** Point clouds are padded to a fixed size (10,000 points) for uniform input dimensions during training.



### Key Components of the Code

#### Architectures

- **Generator and Discriminator:** Feature extraction via fully connected layers.
- **Activation and Normalization:** **SiLU**, **Tanh**, **BatchNorm**, and **GroupNorm** for stable training.

#### Custom Dataset Class

- Reads measurements and loads corresponding `.obj` files.
- Constructs a dataset of paired measurements and point clouds for training.

#### Loss Functions

1. **GAN Loss:** Guides adversarial training by penalizing inaccurate predictions.
2. **Chamfer Distance:** Measures the similarity between real and generated point clouds.

#### Training Loop

- Alternates training between generator and discriminator.
- Saves checkpoint models every few epochs for reproducibility and later use.



### Output

The trained **cGAN** generates 3D avatars based on user-provided measurements. The generated avatars are:
- **Highly detailed:** Contain 10,000 points.
- **Tailored to specific measurements.**
- **Ready for virtual try-on applications,** enabling users to visualize clothing fit on their unique body shapes.


 
## Installation

1. 1. Clone the repository:
   ```bash
   git clone https://github.com/Aideveloper-dev/IEEE_challenge.git
   
   ```
2. Install dependencies:
   ```bash
   pip install -r requirements.txt
   ```
3. Set up the database:
      ```bash
   flask db upgrade
   ```
   flask db upgrade
4. Run the application:
   ```bash
   python run.py
   ```

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

## Directory Details

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






