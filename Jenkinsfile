pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
    }

    stages {
        stage('Set AWS Credentials') {
            steps {
                withCredentials([[
                    $class: 'AmazonWebServicesCredentialsBinding',
                    credentialsId: 'BoSJenkinsAdmin'
                ]]) {
                    sh '''
                    export AWS_DEFAULT_REGION=$AWS_REGION
                    aws sts get-caller-identity
                    '''
                }
            }
        }

        stage('Terraform Format Check') {
            steps {
                {
                    sh '''
                    terraform fmt -check
                    '''
                }
            }
        }

        stage('Terraform Init') {
            steps {
                {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'BoSJenkinsAdmin'
                    ]]) {
                        sh '''
                        export AWS_DEFAULT_REGION=$AWS_REGION
                        terraform init
                        '''
                    }
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                {
                    sh '''
                    terraform validate
                    '''
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'BoSJenkinsAdmin'
                    ]]) {
                        sh '''
                        export AWS_DEFAULT_REGION=$AWS_REGION
                        terraform plan -out=tfplan
                        '''
                    }
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                input message: 'Approve Terraform Apply?', ok: 'Deploy'
                {
                    withCredentials([[
                        $class: 'AmazonWebServicesCredentialsBinding',
                        credentialsId: 'BoSJenkinsAdmin'
                    ]]) {
                        sh '''
                        export AWS_DEFAULT_REGION=$AWS_REGION
                        terraform apply -auto-approve tfplan
                        '''
                    }
                }
            }
        }

        stage('Terraform Destroy (Optional)') {
            steps {
                script {
                    def destroyChoice = input(
                        message: 'Do you want to run terraform destroy?',
                        ok: 'Submit',
                        parameters: [
                            choice(
                                name: 'DESTROY',
                                choices: ['no', 'yes'],
                                description: 'Select yes to destroy resources'
                            )
                        ]
                    )

                    if (destroyChoice == 'yes') {
                        {
                            withCredentials([[
                                $class: 'AmazonWebServicesCredentialsBinding',
                                credentialsId: 'BoSJenkinsAdmin'
                            ]]) {
                                sh '''
                                export AWS_DEFAULT_REGION=$AWS_REGION
                                terraform destroy -auto-approve
                                '''
                            }
                        }
                    } else {
                        echo "Skipping destroy"
                    }
                }
            }
        }
    }

    post {
        success {
            echo 'Terraform pipeline completed successfully!'
        }
        failure {
            echo 'Terraform pipeline failed!'
        }
    }
}