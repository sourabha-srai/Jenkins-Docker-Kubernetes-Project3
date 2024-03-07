pipeline {
    agent any
	tools {
		maven 'Maven'
	}
	
	environment {
		PROJECT_ID = 'vertical-gift-415015'
                CLUSTER_NAME = 'cluster-1'
                LOCATION = 'asia-southeast1-a'
                CREDENTIALS_ID = 'kubernetes'	
		DOCKER_HUB_USER = 'sourabhashettypapt666'
		DOCKER_HUB_REGISTRY = 'devproject-k8'
	}
	
    stages {
	    stage('Scm Checkout') {
		    steps {
			    checkout scm
		    }
	    }
	    
	    stage('Build') {
		    steps {
			    sh 'mvn clean package'
		    }
	    }
	    
	    stage('Test') {
		    steps {
			    echo "Testing..."
			    sh 'mvn test'
		    }
	    }
	    
	    stage('Build Docker Image') {
		    steps {
			    sh 'whoami'
			    script {
	            // Make sure Docker is installed on the Jenkins agent
	
	            // Check if there are running containers before attempting to stop them
	            def runningContainers = sh(script: 'docker ps -q', returnStdout: true).trim()
	            
	            if (runningContainers) {
	                sh "docker stop \$(docker ps -a -q) && docker container prune -f"
	            }
	
	            sh "docker image prune -f"
	            sh "docker build -t ${DOCKER_HUB_USER}/${DOCKER_HUB_REGISTRY}:${BUILD_NUMBER} ."
	        }
		    }
	    }
	    
	    stage("Push Docker Image") {
		    steps {
			    script {
				    echo "Push Docker Image"
				    withCredentials([string(credentialsId: 'dockerhub', variable: 'dockerhub')]) {
            				sh "docker login -u sourabhashettypapt666 -p ${dockerhub}"
				    }
				      sh "docker push ${DOCKER_HUB_USER}/${DOCKER_HUB_REGISTRY}:${BUILD_NUMBER}"
				    
			    }
		    }
	    }
	    
	    stage('Deploy to K8s') {
		    steps{
			    echo "Deployment started ..."
			    sh 'ls -ltr'
			    sh 'pwd'
			    sh "sed -i 's/tagversion/${env.BUILD_ID}/g' serviceLB.yaml"
				sh "sed -i 's/tagversion/${env.BUILD_ID}/g' deployment.yaml"
			    echo "Start deployment of serviceLB.yaml"
			    step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'serviceLB.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
				echo "Start deployment of deployment.yaml"
				step([$class: 'KubernetesEngineBuilder', projectId: env.PROJECT_ID, clusterName: env.CLUSTER_NAME, location: env.LOCATION, manifestPattern: 'deployment.yaml', credentialsId: env.CREDENTIALS_ID, verifyDeployments: true])
			    echo "Deployment Finished ..."
		    }
	    }
    }
}
