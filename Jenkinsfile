pipeline{

    //agent {label 'docker-node'}
    //agent { label 'jenkins-agent' }
    //agent { label 'Demo' }
    agent any
    parameters{

        choice(name: 'action', choices: 'create\nupdate\ndelete', description: 'Choose create/Destroy')
        string(name: 'ImageName', description: "name of the docker build", defaultValue: 'node-js-app')
        string(name: 'ImageTag', description: "tag of the docker build", defaultValue: 'v1')
        string(name: 'DockerHubUser', description: "name of the Application", defaultValue: 'pragnesh9789')
    }
    
    stages{ 
        stage('Echo'){
            steps{
                echo "Hello, value of the action $Action"
            }
        }
        
        stage('Remove any previous repo'){
            when { expression {  params.action == 'create' } }
            steps{
            sh """
            rm -r $workspace/node-js-app --force
            """
            }
        }
        
        stage('Git Checkout'){
            when { expression {  params.action == 'create' } }
            steps{
            sh """
            git clone https://github.com/Pragnesh8900/node-js-app.git
            """
            }
        }

        stage('Git Pull'){            
            when { expression {  params.action == 'update' } }
            steps{
            sh """
            cd $workspace/node-js-app
            git pull https://patelpragnesh8900%40gmail.com:Pragnesh%409789@github.com/Pragnesh8900/node-js-app.git
            """
            }            
        }
        
        stage('Docker Image Build'){
//         when { expression {  params.action == 'create' } }
            steps{
               script{
                sh """
                cd node-js-app
                docker build -t ${params.DockerHubUser}/${params.ImageName}:${params.ImageTag} .
                """   
                }
            }
        }
        
        stage('Docker Image Push : DockerHub '){
//         when { expression {  params.action == 'create' } }
            steps{
               script{
                withCredentials([usernamePassword(
                    credentialsId: "docker",
                    usernameVariable: "USER",
                    passwordVariable: "PASS"
                )]) {
                    sh "docker login -u '$USER' -p '$PASS'"
                    }
                //sh "docker image push ${hubUser}/${project}:${ImageTag}"
                sh "docker image push ${params.DockerHubUser}/${params.ImageName}:${params.ImageTag}"   
                }   
            }
        }
        
        stage('Docker Image Remove'){
//         when { expression {  params.action == 'create' } }
            steps{
               script{
                sh """
                docker rmi ${params.DockerHubUser}/${params.ImageName}:${params.ImageTag}
                """   
                }
            }
        }
        
        stage('Kubernetes Deployment'){
         when { expression {  params.action == 'create' } }
            steps{
               script{
                sh """
                cd node-js-app/Terraform
                sed -i "s/latest/${params.ImageTag}/g" config.tf
                terraform init
                terraform plan -out "file.plan"
                terraform apply "file.plan"
                sed -i "s/${params.ImageTag}/latest/g" config.tf
                """   
                }
            }
        }
        
        stage('Update Kubernetes Deployment'){
            when { expression {  params.action == 'update' } }
            steps{
            sh """
            cd node-js-app/Terraform
            sed -i "s/latest/${params.ImageTag}/g" config.tf
            terraform apply -auto-approve
            sed -i "s/${params.ImageTag}/latest/g" config.tf
            """
            }
        }
    }
}
