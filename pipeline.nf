#!/usr/bin/env nextflow

nextflow.enable.dsl=2


process sayHello { 
    // pod nodeSelector: 'workload=Memory' 

    output:
    path "hello-world.txt", emit: hello_file
    script:
    """
    sleep 1
    echo "Hello !" ~ > hello-world.txt
    ls -l /data/ >> hello-world.txt
    ls -l /mnt/workspace/ >> hello-world.txt
    echo "Fichier hello-world.txt créé par sayHello."

    """
}

process processGreeting {
    // pod nodeSelector: 'workload=CPU' 

    
    input:
    path greeting_file 

    output:
    stdout emit: confirmation 

    script:
    """
    sleep 1
    echo "--- processGreeting a reçu le fichier : ${greeting_file} ---"
    echo "Contenu du fichier :"
    cat "${greeting_file}"
    echo "--- Fin du contenu ---"
    """
}


workflow {
    hello_channel = sayHello()

    // confirmation_channel = processGreeting(hello_channel.hello_file)

    // confirmation_channel.view { ligne -> "Sortie de processGreeting: $ligne" }
}
