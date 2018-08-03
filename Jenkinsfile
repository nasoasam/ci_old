node{
    sh 'mvn --version'
    sh 'mvn spring-boot:run'

    def branches = [:]
    
    for(int i = 0; i < 20; i++) {
        int port=60000 + i
        branches["split${i}"] = {
            node {
                docker.image('httpd').inside("-u root:root -p ${port}:80") {
                    echo "${port}"
                    sh "httpd-foreground &"
                    sleep 30
                }
            }
        }
    }
    parallel branches

}
