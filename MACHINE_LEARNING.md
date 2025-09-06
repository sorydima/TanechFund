# Machine Learning Guide - REChain VC Lab

## 🤖 Machine Learning Overview

This document outlines our comprehensive machine learning strategy for REChain VC Lab, covering AI/ML integration, data science workflows, model deployment, and intelligent features.

## 🎯 ML Principles

### Core Principles

#### 1. Data-Driven Decisions
- **Quality Data**: High-quality, clean, and relevant data
- **Data Privacy**: Protect user privacy and data security
- **Ethical AI**: Fair, transparent, and accountable AI
- **Continuous Learning**: Continuously improve models

#### 2. User Experience
- **Personalization**: Personalized user experiences
- **Intelligent Automation**: Automate repetitive tasks
- **Predictive Analytics**: Anticipate user needs
- **Natural Interaction**: Natural language and voice interfaces

#### 3. Technical Excellence
- **Scalable Architecture**: Scalable ML infrastructure
- **Model Performance**: High accuracy and low latency
- **Monitoring**: Comprehensive model monitoring
- **Version Control**: Track model versions and changes

#### 4. Business Value
- **ROI**: Clear return on investment
- **Competitive Advantage**: Gain competitive advantage
- **User Engagement**: Increase user engagement
- **Revenue Growth**: Drive revenue growth

## 🏗️ ML Architecture

### ML Pipeline

#### 1. Data Pipeline
```python
# ml/pipeline/data_pipeline.py
import pandas as pd
import numpy as np
from sklearn.preprocessing import StandardScaler, LabelEncoder
from sklearn.model_selection import train_test_split
import logging

class DataPipeline:
    def __init__(self, config):
        self.config = config
        self.scaler = StandardScaler()
        self.label_encoder = LabelEncoder()
        self.logger = logging.getLogger(__name__)
    
    def load_data(self, data_path):
        """Load data from various sources"""
        try:
            if data_path.endswith('.csv'):
                data = pd.read_csv(data_path)
            elif data_path.endswith('.json'):
                data = pd.read_json(data_path)
            elif data_path.endswith('.parquet'):
                data = pd.read_parquet(data_path)
            else:
                raise ValueError(f"Unsupported file format: {data_path}")
            
            self.logger.info(f"Loaded data with shape: {data.shape}")
            return data
        except Exception as e:
            self.logger.error(f"Error loading data: {e}")
            raise
    
    def clean_data(self, data):
        """Clean and preprocess data"""
        # Remove duplicates
        data = data.drop_duplicates()
        
        # Handle missing values
        data = data.fillna(data.mean())
        
        # Remove outliers
        for column in data.select_dtypes(include=[np.number]).columns:
            Q1 = data[column].quantile(0.25)
            Q3 = data[column].quantile(0.75)
            IQR = Q3 - Q1
            lower_bound = Q1 - 1.5 * IQR
            upper_bound = Q3 + 1.5 * IQR
            data = data[(data[column] >= lower_bound) & (data[column] <= upper_bound)]
        
        self.logger.info(f"Cleaned data shape: {data.shape}")
        return data
    
    def feature_engineering(self, data):
        """Create new features"""
        # Create time-based features
        if 'created_at' in data.columns:
            data['hour'] = pd.to_datetime(data['created_at']).dt.hour
            data['day_of_week'] = pd.to_datetime(data['created_at']).dt.dayofweek
            data['month'] = pd.to_datetime(data['created_at']).dt.month
        
        # Create interaction features
        if 'user_age' in data.columns and 'user_activity' in data.columns:
            data['age_activity_interaction'] = data['user_age'] * data['user_activity']
        
        # Create categorical features
        if 'category' in data.columns:
            data['category_encoded'] = self.label_encoder.fit_transform(data['category'])
        
        self.logger.info(f"Feature engineering completed. New shape: {data.shape}")
        return data
    
    def prepare_features(self, data, target_column):
        """Prepare features for training"""
        # Separate features and target
        X = data.drop(columns=[target_column])
        y = data[target_column]
        
        # Encode categorical variables
        categorical_columns = X.select_dtypes(include=['object']).columns
        for col in categorical_columns:
            X[col] = self.label_encoder.fit_transform(X[col])
        
        # Scale numerical features
        numerical_columns = X.select_dtypes(include=[np.number]).columns
        X[numerical_columns] = self.scaler.fit_transform(X[numerical_columns])
        
        return X, y
    
    def split_data(self, X, y, test_size=0.2, random_state=42):
        """Split data into train and test sets"""
        X_train, X_test, y_train, y_test = train_test_split(
            X, y, test_size=test_size, random_state=random_state, stratify=y
        )
        
        self.logger.info(f"Data split - Train: {X_train.shape}, Test: {X_test.shape}")
        return X_train, X_test, y_train, y_test
```

#### 2. Model Training
```python
# ml/models/model_trainer.py
import joblib
import numpy as np
from sklearn.ensemble import RandomForestClassifier, GradientBoostingClassifier
from sklearn.linear_model import LogisticRegression
from sklearn.svm import SVC
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
from sklearn.model_selection import cross_val_score, GridSearchCV
import logging

class ModelTrainer:
    def __init__(self, config):
        self.config = config
        self.models = {}
        self.best_model = None
        self.logger = logging.getLogger(__name__)
    
    def train_models(self, X_train, y_train, X_test, y_test):
        """Train multiple models and select the best one"""
        models = {
            'random_forest': RandomForestClassifier(
                n_estimators=100,
                random_state=42,
                n_jobs=-1
            ),
            'gradient_boosting': GradientBoostingClassifier(
                n_estimators=100,
                random_state=42
            ),
            'logistic_regression': LogisticRegression(
                random_state=42,
                max_iter=1000
            ),
            'svm': SVC(
                random_state=42,
                probability=True
            )
        }
        
        best_score = 0
        best_model_name = None
        
        for name, model in models.items():
            self.logger.info(f"Training {name}...")
            
            # Train model
            model.fit(X_train, y_train)
            
            # Make predictions
            y_pred = model.predict(X_test)
            
            # Calculate metrics
            accuracy = accuracy_score(y_test, y_pred)
            precision = precision_score(y_test, y_pred, average='weighted')
            recall = recall_score(y_test, y_pred, average='weighted')
            f1 = f1_score(y_test, y_pred, average='weighted')
            
            self.logger.info(f"{name} - Accuracy: {accuracy:.4f}, F1: {f1:.4f}")
            
            # Store model
            self.models[name] = {
                'model': model,
                'accuracy': accuracy,
                'precision': precision,
                'recall': recall,
                'f1': f1
            }
            
            # Update best model
            if f1 > best_score:
                best_score = f1
                best_model_name = name
                self.best_model = model
        
        self.logger.info(f"Best model: {best_model_name} with F1 score: {best_score:.4f}")
        return self.best_model
    
    def hyperparameter_tuning(self, X_train, y_train, model_name='random_forest'):
        """Perform hyperparameter tuning"""
        if model_name == 'random_forest':
            param_grid = {
                'n_estimators': [50, 100, 200],
                'max_depth': [10, 20, None],
                'min_samples_split': [2, 5, 10],
                'min_samples_leaf': [1, 2, 4]
            }
            model = RandomForestClassifier(random_state=42)
        
        elif model_name == 'gradient_boosting':
            param_grid = {
                'n_estimators': [50, 100, 200],
                'learning_rate': [0.01, 0.1, 0.2],
                'max_depth': [3, 5, 7],
                'subsample': [0.8, 0.9, 1.0]
            }
            model = GradientBoostingClassifier(random_state=42)
        
        else:
            self.logger.warning(f"Hyperparameter tuning not supported for {model_name}")
            return None
        
        # Grid search
        grid_search = GridSearchCV(
            model, param_grid, cv=5, scoring='f1_weighted', n_jobs=-1
        )
        grid_search.fit(X_train, y_train)
        
        self.logger.info(f"Best parameters: {grid_search.best_params_}")
        self.logger.info(f"Best score: {grid_search.best_score_:.4f}")
        
        return grid_search.best_estimator_
    
    def save_model(self, model, model_path):
        """Save trained model"""
        joblib.dump(model, model_path)
        self.logger.info(f"Model saved to {model_path}")
    
    def load_model(self, model_path):
        """Load trained model"""
        model = joblib.load(model_path)
        self.logger.info(f"Model loaded from {model_path}")
        return model
```

#### 3. Model Deployment
```python
# ml/deployment/model_deployment.py
import joblib
import numpy as np
import pandas as pd
from flask import Flask, request, jsonify
import logging
import os

class ModelDeployment:
    def __init__(self, model_path, scaler_path, label_encoder_path):
        self.model = joblib.load(model_path)
        self.scaler = joblib.load(scaler_path)
        self.label_encoder = joblib.load(label_encoder_path)
        self.logger = logging.getLogger(__name__)
    
    def preprocess_input(self, data):
        """Preprocess input data"""
        # Convert to DataFrame if needed
        if isinstance(data, dict):
            data = pd.DataFrame([data])
        
        # Handle categorical variables
        categorical_columns = data.select_dtypes(include=['object']).columns
        for col in categorical_columns:
            if col in data.columns:
                data[col] = self.label_encoder.transform(data[col])
        
        # Scale numerical features
        numerical_columns = data.select_dtypes(include=[np.number]).columns
        data[numerical_columns] = self.scaler.transform(data[numerical_columns])
        
        return data
    
    def predict(self, data):
        """Make predictions"""
        try:
            # Preprocess data
            processed_data = self.preprocess_input(data)
            
            # Make prediction
            prediction = self.model.predict(processed_data)
            probability = self.model.predict_proba(processed_data)
            
            return {
                'prediction': prediction.tolist(),
                'probability': probability.tolist(),
                'confidence': float(np.max(probability))
            }
        except Exception as e:
            self.logger.error(f"Prediction error: {e}")
            return {'error': str(e)}
    
    def create_api(self):
        """Create Flask API for model serving"""
        app = Flask(__name__)
        
        @app.route('/predict', methods=['POST'])
        def predict_endpoint():
            try:
                data = request.get_json()
                result = self.predict(data)
                return jsonify(result)
            except Exception as e:
                return jsonify({'error': str(e)}), 400
        
        @app.route('/health', methods=['GET'])
        def health_check():
            return jsonify({'status': 'healthy'})
        
        return app
```

## 🧠 AI Features

### 1. Personalized Recommendations

#### Recommendation Engine
```python
# ml/features/recommendation_engine.py
import numpy as np
from sklearn.metrics.pairwise import cosine_similarity
from sklearn.feature_extraction.text import TfidfVectorizer
import pandas as pd

class RecommendationEngine:
    def __init__(self):
        self.user_item_matrix = None
        self.item_features = None
        self.user_features = None
        self.tfidf_vectorizer = TfidfVectorizer(max_features=1000)
    
    def build_user_item_matrix(self, interactions):
        """Build user-item interaction matrix"""
        self.user_item_matrix = interactions.pivot_table(
            index='user_id',
            columns='item_id',
            values='rating',
            fill_value=0
        )
        return self.user_item_matrix
    
    def collaborative_filtering(self, user_id, n_recommendations=10):
        """Collaborative filtering recommendations"""
        if user_id not in self.user_item_matrix.index:
            return []
        
        # Get user vector
        user_vector = self.user_item_matrix.loc[user_id].values.reshape(1, -1)
        
        # Calculate similarities
        similarities = cosine_similarity(
            user_vector,
            self.user_item_matrix.values
        )[0]
        
        # Get similar users
        similar_users = np.argsort(similarities)[::-1][1:11]  # Top 10 similar users
        
        # Get items liked by similar users
        recommendations = []
        for similar_user_idx in similar_users:
            similar_user_id = self.user_item_matrix.index[similar_user_idx]
            user_items = self.user_item_matrix.loc[similar_user_id]
            liked_items = user_items[user_items > 0].index.tolist()
            recommendations.extend(liked_items)
        
        # Remove duplicates and items already liked by user
        user_liked_items = set(
            self.user_item_matrix.loc[user_id][
                self.user_item_matrix.loc[user_id] > 0
            ].index
        )
        recommendations = list(set(recommendations) - user_liked_items)
        
        return recommendations[:n_recommendations]
    
    def content_based_filtering(self, user_id, n_recommendations=10):
        """Content-based filtering recommendations"""
        if user_id not in self.user_item_matrix.index:
            return []
        
        # Get user's liked items
        user_items = self.user_item_matrix.loc[user_id]
        liked_items = user_items[user_items > 0].index.tolist()
        
        if not liked_items:
            return []
        
        # Get item features
        item_features = self.tfidf_vectorizer.fit_transform(
            self.item_features['description']
        )
        
        # Calculate user profile
        user_profile = np.mean(
            item_features[liked_items], axis=0
        )
        
        # Calculate similarities
        similarities = cosine_similarity(
            user_profile.reshape(1, -1),
            item_features
        )[0]
        
        # Get recommendations
        recommendations = np.argsort(similarities)[::-1]
        recommendations = [
            idx for idx in recommendations
            if idx not in liked_items
        ]
        
        return recommendations[:n_recommendations]
    
    def hybrid_recommendations(self, user_id, n_recommendations=10):
        """Hybrid recommendations combining collaborative and content-based"""
        # Get collaborative filtering recommendations
        cf_recommendations = self.collaborative_filtering(user_id, n_recommendations)
        
        # Get content-based recommendations
        cb_recommendations = self.content_based_filtering(user_id, n_recommendations)
        
        # Combine recommendations
        all_recommendations = list(set(cf_recommendations + cb_recommendations))
        
        return all_recommendations[:n_recommendations]
```

### 2. Natural Language Processing

#### NLP Service
```python
# ml/features/nlp_service.py
import spacy
import nltk
from textblob import TextBlob
from transformers import pipeline
import re

class NLPService:
    def __init__(self):
        self.nlp = spacy.load("en_core_web_sm")
        self.sentiment_analyzer = pipeline("sentiment-analysis")
        self.text_classifier = pipeline("zero-shot-classification")
    
    def preprocess_text(self, text):
        """Preprocess text for NLP tasks"""
        # Convert to lowercase
        text = text.lower()
        
        # Remove special characters
        text = re.sub(r'[^a-zA-Z0-9\s]', '', text)
        
        # Remove extra whitespace
        text = re.sub(r'\s+', ' ', text).strip()
        
        return text
    
    def extract_entities(self, text):
        """Extract named entities from text"""
        doc = self.nlp(text)
        entities = []
        
        for ent in doc.ents:
            entities.append({
                'text': ent.text,
                'label': ent.label_,
                'start': ent.start_char,
                'end': ent.end_char
            })
        
        return entities
    
    def extract_keywords(self, text, n_keywords=10):
        """Extract keywords from text"""
        doc = self.nlp(text)
        keywords = []
        
        for token in doc:
            if (token.pos_ in ['NOUN', 'ADJ', 'VERB'] and 
                not token.is_stop and 
                not token.is_punct and 
                len(token.text) > 2):
                keywords.append(token.lemma_)
        
        # Count keyword frequency
        keyword_counts = {}
        for keyword in keywords:
            keyword_counts[keyword] = keyword_counts.get(keyword, 0) + 1
        
        # Sort by frequency
        sorted_keywords = sorted(
            keyword_counts.items(),
            key=lambda x: x[1],
            reverse=True
        )
        
        return [keyword for keyword, count in sorted_keywords[:n_keywords]]
    
    def analyze_sentiment(self, text):
        """Analyze sentiment of text"""
        # Using TextBlob
        blob = TextBlob(text)
        polarity = blob.sentiment.polarity
        
        # Using transformers
        result = self.sentiment_analyzer(text)
        
        return {
            'textblob_polarity': polarity,
            'textblob_sentiment': 'positive' if polarity > 0 else 'negative' if polarity < 0 else 'neutral',
            'transformers_result': result[0]
        }
    
    def classify_text(self, text, categories):
        """Classify text into categories"""
        result = self.text_classifier(text, categories)
        return {
            'labels': result['labels'],
            'scores': result['scores']
        }
    
    def summarize_text(self, text, max_length=100):
        """Summarize text"""
        doc = self.nlp(text)
        sentences = [sent.text for sent in doc.sents]
        
        # Simple extractive summarization
        sentence_scores = {}
        for sentence in sentences:
            score = len(sentence.split())  # Simple scoring based on length
            sentence_scores[sentence] = score
        
        # Sort sentences by score
        sorted_sentences = sorted(
            sentence_scores.items(),
            key=lambda x: x[1],
            reverse=True
        )
        
        # Select top sentences
        summary_sentences = [sent for sent, score in sorted_sentences[:3]]
        summary = ' '.join(summary_sentences)
        
        return summary[:max_length]
```

### 3. Computer Vision

#### Image Processing Service
```python
# ml/features/image_processing.py
import cv2
import numpy as np
from PIL import Image
import tensorflow as tf
from tensorflow.keras.applications import ResNet50, VGG16
from tensorflow.keras.preprocessing import image
from tensorflow.keras.applications.resnet50 import preprocess_input, decode_predictions

class ImageProcessingService:
    def __init__(self):
        self.resnet_model = ResNet50(weights='imagenet')
        self.vgg_model = VGG16(weights='imagenet')
    
    def preprocess_image(self, image_path, target_size=(224, 224)):
        """Preprocess image for model input"""
        img = image.load_img(image_path, target_size=target_size)
        img_array = image.img_to_array(img)
        img_array = np.expand_dims(img_array, axis=0)
        img_array = preprocess_input(img_array)
        return img_array
    
    def classify_image(self, image_path):
        """Classify image using pre-trained models"""
        # Preprocess image
        img_array = self.preprocess_image(image_path)
        
        # Make prediction
        predictions = self.resnet_model.predict(img_array)
        decoded_predictions = decode_predictions(predictions, top=5)[0]
        
        return [
            {
                'class': pred[1],
                'confidence': float(pred[2])
            }
            for pred in decoded_predictions
        ]
    
    def extract_features(self, image_path):
        """Extract features from image"""
        img_array = self.preprocess_image(image_path)
        
        # Extract features using ResNet50
        features = self.resnet_model.predict(img_array)
        features = features.flatten()
        
        return features.tolist()
    
    def detect_objects(self, image_path):
        """Detect objects in image"""
        # Load image
        img = cv2.imread(image_path)
        img_rgb = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)
        
        # Load pre-trained model
        net = cv2.dnn.readNetFromDarknet(
            'yolov3.cfg',
            'yolov3.weights'
        )
        
        # Get layer names
        layer_names = net.getLayerNames()
        output_layers = [layer_names[i[0] - 1] for i in net.getUnconnectedOutLayers()]
        
        # Prepare image
        blob = cv2.dnn.blobFromImage(
            img_rgb, 0.00392, (416, 416), (0, 0, 0), True, crop=False
        )
        
        # Set input
        net.setInput(blob)
        outputs = net.forward(output_layers)
        
        # Process outputs
        objects = []
        for output in outputs:
            for detection in output:
                scores = detection[5:]
                class_id = np.argmax(scores)
                confidence = scores[class_id]
                
                if confidence > 0.5:
                    objects.append({
                        'class_id': int(class_id),
                        'confidence': float(confidence)
                    })
        
        return objects
    
    def enhance_image(self, image_path, enhancement_type='sharpen'):
        """Enhance image quality"""
        img = cv2.imread(image_path)
        
        if enhancement_type == 'sharpen':
            kernel = np.array([[-1, -1, -1],
                             [-1, 9, -1],
                             [-1, -1, -1]])
            enhanced = cv2.filter2D(img, -1, kernel)
        
        elif enhancement_type == 'denoise':
            enhanced = cv2.fastNlMeansDenoisingColored(img, None, 10, 10, 7, 21)
        
        elif enhancement_type == 'brightness':
            enhanced = cv2.convertScaleAbs(img, alpha=1.2, beta=30)
        
        else:
            enhanced = img
        
        return enhanced
```

## 📊 Model Monitoring

### Model Performance Monitoring

#### 1. Performance Metrics
```python
# ml/monitoring/model_monitoring.py
import numpy as np
import pandas as pd
from sklearn.metrics import accuracy_score, precision_score, recall_score, f1_score
import logging
import time

class ModelMonitoring:
    def __init__(self, model, threshold=0.8):
        self.model = model
        self.threshold = threshold
        self.performance_history = []
        self.logger = logging.getLogger(__name__)
    
    def calculate_metrics(self, y_true, y_pred):
        """Calculate performance metrics"""
        metrics = {
            'accuracy': accuracy_score(y_true, y_pred),
            'precision': precision_score(y_true, y_pred, average='weighted'),
            'recall': recall_score(y_true, y_pred, average='weighted'),
            'f1_score': f1_score(y_true, y_pred, average='weighted'),
            'timestamp': time.time()
        }
        
        return metrics
    
    def monitor_performance(self, X_test, y_test):
        """Monitor model performance"""
        # Make predictions
        y_pred = self.model.predict(X_test)
        
        # Calculate metrics
        metrics = self.calculate_metrics(y_test, y_pred)
        
        # Store metrics
        self.performance_history.append(metrics)
        
        # Check for performance degradation
        if metrics['f1_score'] < self.threshold:
            self.logger.warning(f"Performance degradation detected: {metrics['f1_score']:.4f}")
            self.trigger_retraining()
        
        return metrics
    
    def detect_drift(self, new_data, reference_data):
        """Detect data drift"""
        # Calculate statistical differences
        drift_detected = False
        
        for column in new_data.columns:
            if column in reference_data.columns:
                # Kolmogorov-Smirnov test
                from scipy.stats import ks_2samp
                statistic, p_value = ks_2samp(
                    reference_data[column].dropna(),
                    new_data[column].dropna()
                )
                
                if p_value < 0.05:  # Significant difference
                    drift_detected = True
                    self.logger.warning(f"Data drift detected in column: {column}")
        
        return drift_detected
    
    def trigger_retraining(self):
        """Trigger model retraining"""
        self.logger.info("Triggering model retraining...")
        # Implementation for retraining
        pass
    
    def generate_report(self):
        """Generate performance report"""
        if not self.performance_history:
            return "No performance data available"
        
        df = pd.DataFrame(self.performance_history)
        
        report = {
            'current_performance': df.iloc[-1].to_dict(),
            'average_performance': df.mean().to_dict(),
            'performance_trend': df['f1_score'].tolist(),
            'total_predictions': len(self.performance_history)
        }
        
        return report
```

#### 2. Real-time Monitoring
```python
# ml/monitoring/real_time_monitoring.py
import asyncio
import websockets
import json
import logging
from datetime import datetime

class RealTimeMonitoring:
    def __init__(self, model_monitor):
        self.model_monitor = model_monitor
        self.connections = set()
        self.logger = logging.getLogger(__name__)
    
    async def register_connection(self, websocket, path):
        """Register new WebSocket connection"""
        self.connections.add(websocket)
        self.logger.info(f"New connection: {websocket.remote_address}")
        
        try:
            await websocket.wait_closed()
        finally:
            self.connections.remove(websocket)
    
    async def broadcast_metrics(self, metrics):
        """Broadcast metrics to all connected clients"""
        if self.connections:
            message = json.dumps({
                'type': 'metrics',
                'data': metrics,
                'timestamp': datetime.now().isoformat()
            })
            
            # Send to all connections
            disconnected = set()
            for connection in self.connections:
                try:
                    await connection.send(message)
                except websockets.exceptions.ConnectionClosed:
                    disconnected.add(connection)
            
            # Remove disconnected connections
            self.connections -= disconnected
    
    async def start_monitoring(self, port=8765):
        """Start real-time monitoring server"""
        start_server = websockets.serve(
            self.register_connection,
            "localhost",
            port
        )
        
        self.logger.info(f"Starting monitoring server on port {port}")
        await start_server
        
        # Keep server running
        await asyncio.Future()
```

## 🔧 MLOps Integration

### CI/CD for ML

#### 1. ML Pipeline CI/CD
```yaml
# .github/workflows/ml-pipeline.yml
name: ML Pipeline CI/CD

on:
  push:
    branches: [ main, develop ]
    paths: [ 'ml/**' ]
  pull_request:
    branches: [ main, develop ]
    paths: [ 'ml/**' ]

jobs:
  data-validation:
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'
    
    - name: Install dependencies
      run: |
        pip install -r ml/requirements.txt
        pip install great-expectations
    
    - name: Validate data
      run: |
        python ml/validation/validate_data.py
        python ml/validation/data_quality_check.py
    
    - name: Upload validation results
      uses: actions/upload-artifact@v3
      with:
        name: validation-results
        path: ml/validation/results/

  model-training:
    needs: data-validation
    runs-on: ubuntu-latest
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Set up Python
      uses: actions/setup-python@v4
      with:
        python-version: '3.9'
    
    - name: Install dependencies
      run: pip install -r ml/requirements.txt
    
    - name: Train model
      run: python ml/training/train_model.py
    
    - name: Evaluate model
      run: python ml/evaluation/evaluate_model.py
    
    - name: Upload model artifacts
      uses: actions/upload-artifact@v3
      with:
        name: model-artifacts
        path: ml/models/

  model-deployment:
    needs: model-training
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - name: Checkout code
      uses: actions/checkout@v4
    
    - name: Download model artifacts
      uses: actions/download-artifact@v3
      with:
        name: model-artifacts
        path: ml/models/
    
    - name: Deploy model
      run: python ml/deployment/deploy_model.py
    
    - name: Run integration tests
      run: python ml/tests/integration_tests.py
```

#### 2. Model Versioning
```python
# ml/versioning/model_versioning.py
import os
import shutil
import json
from datetime import datetime
import hashlib

class ModelVersioning:
    def __init__(self, model_dir="ml/models"):
        self.model_dir = model_dir
        self.version_file = os.path.join(model_dir, "versions.json")
    
    def create_version(self, model, metadata):
        """Create a new model version"""
        # Generate version ID
        version_id = self.generate_version_id(model, metadata)
        
        # Create version directory
        version_dir = os.path.join(self.model_dir, version_id)
        os.makedirs(version_dir, exist_ok=True)
        
        # Save model
        model_path = os.path.join(version_dir, "model.pkl")
        self.save_model(model, model_path)
        
        # Save metadata
        metadata_path = os.path.join(version_dir, "metadata.json")
        with open(metadata_path, 'w') as f:
            json.dump(metadata, f, indent=2)
        
        # Update versions file
        self.update_versions_file(version_id, metadata)
        
        return version_id
    
    def generate_version_id(self, model, metadata):
        """Generate unique version ID"""
        # Create hash from model and metadata
        model_str = str(model.get_params())
        metadata_str = json.dumps(metadata, sort_keys=True)
        combined = model_str + metadata_str
        
        hash_object = hashlib.md5(combined.encode())
        return hash_object.hexdigest()[:8]
    
    def save_model(self, model, path):
        """Save model to file"""
        import joblib
        joblib.dump(model, path)
    
    def load_model(self, version_id):
        """Load model by version ID"""
        model_path = os.path.join(self.model_dir, version_id, "model.pkl")
        import joblib
        return joblib.load(model_path)
    
    def get_latest_version(self):
        """Get latest model version"""
        if not os.path.exists(self.version_file):
            return None
        
        with open(self.version_file, 'r') as f:
            versions = json.load(f)
        
        if not versions:
            return None
        
        # Sort by timestamp and return latest
        latest = max(versions, key=lambda x: x['timestamp'])
        return latest['version_id']
    
    def update_versions_file(self, version_id, metadata):
        """Update versions file with new version"""
        versions = []
        if os.path.exists(self.version_file):
            with open(self.version_file, 'r') as f:
                versions = json.load(f)
        
        versions.append({
            'version_id': version_id,
            'timestamp': datetime.now().isoformat(),
            'metadata': metadata
        })
        
        with open(self.version_file, 'w') as f:
            json.dump(versions, f, indent=2)
```

## 📞 Contact Information

### ML Team
- **Email**: ml@rechain.network
- **Phone**: +1-555-MACHINE-LEARNING
- **Slack**: #ml channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### Data Science Team
- **Email**: datascience@rechain.network
- **Phone**: +1-555-DATA-SCIENCE
- **Slack**: #data-science channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

### AI Team
- **Email**: ai@rechain.network
- **Phone**: +1-555-AI
- **Slack**: #ai channel
- **Office Hours**: Monday-Friday, 9 AM - 5 PM UTC

---

**Building intelligent applications with AI/ML! 🤖**

*This machine learning guide is effective as of September 4, 2024, and will be reviewed quarterly.*

**Last Updated**: 2024-09-04
**Version**: 1.0.0
**Machine Learning Guide Version**: 1.0.0
