node{
    def branches = [:]
    def c = [:]
    def dockerimage
    dockerimage = docker.build('mybuilder')
    for(int i = 0; i < 2; i++) {
        int port=60000 + i
        branches["split${i}"] = {
            node {
                checkout scm
                parallel (
                    spring : {
                        c["${port}"] = dockerimage.run("-u root:root -v $HOME/.m2:/root/.m2 -p ${port}:8080")
                        c["${port}"].inside() {
                            sh 'mvn spring-boot:run'
                        }
                    },
                    selenium : {
                        sleep 60
                        print "---"
                        print c["${port}"].id
                        print "==="
                        c["${port}"].stop()
                    }
                )
            }
        }
    }
    parallel branches

}
