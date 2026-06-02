# Bayan – Arabic Stuttering Detection System

An AI-powered graduation project designed to detect stuttering patterns in Arabic speech using deep learning techniques.

## Project Type

Graduation Project | Artificial Intelligence | Speech Processing | Deep Learning

## Overview

Bayan analyzes speech recordings and identifies different stuttering events such as:

- Sound Repetition
- Word Repetition
- Prolongation
- Blocks
- Interjections

The system aims to support speech therapists by providing automatic and objective speech analysis.

## Architecture

The system consists of three main components:

- Mobile Application (SwiftUI)
- Deep Learning Model (Wav2Vec2 XLS-R)
- Audio Processing Pipeline

The user records speech through the mobile application, the audio is processed and analyzed by the trained model, and the results are returned to the user.

## Dataset

- Arabic Dataset: 533 speech recordings
- English Dataset: SEP-28K (20,906 samples)

The datasets were used to train and evaluate the stuttering detection model.

## Results

The trained model achieved promising results in detecting multiple stuttering patterns.

- Macro F1 Score: 0.71
- Weighted F1 Score: 0.71

The model successfully detected:
- Prolongation
- Block
- Sound Repetition
- Word Repetition
- Interjection

## Technologies Used

- Python
- PyTorch
- Wav2Vec2 XLS-R
- Jupyter Notebook
- SwiftUI
- Xcode
- GitHub

## Features

- Arabic speech recording
- AI-based stuttering detection
- Multi-label classification
- Real-time analysis results
- User-friendly mobile interface

## My Contribution

- Requirements analysis and system specification
- System architecture and database design
- Literature review and research analysis
- Model evaluation and result interpretation
- Documentation and presentation preparation

## Screenshots

### Home Screen
![Home Screen](screenshots/Home%20Screen.png)

### Privacy Permission Screen 1
![Privacy Permission Screen 1](screenshots/Privacy%20Permission%20Screen%201.png)

### Privacy Permission Screen 2
![Privacy Permission Screen 2](screenshots/Privacy%20Permission%20Screen%202.png)

### Recording Screen 1
![Recording Screen 1](screenshots/Recording%20Screen%201.png)

### Recording Screen 2
![Recording Screen 2](screenshots/Recording%20Screen%202.png)

### Result Screen 1
![Result Screen 1](screenshots/Result%20Screen%201.png)

### Result Screen 2
![Result Screen 2](screenshots/Result%20Screen%202.png)

## Future Work

- Expand the Arabic speech dataset with more speakers and dialects.
- Improve detection accuracy for complex stuttering events.
- Support real-time speech analysis.
- Integrate the system with clinical speech therapy workflows.

## Team

This project was developed as part of a graduation project team.

## Project Status

Completed and presented as a Graduation Project in the College of Computer and Information Sciences at Imam Mohammad Ibn Saud Islamic University.
