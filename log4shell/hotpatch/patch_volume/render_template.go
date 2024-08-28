package main

import (
	"fmt"
	"html/template"
	"io/ioutil"
	"log"
	"os"

	"github.com/ghodss/yaml"
)

func readValues(path string) (map[string]interface{}, error) {
	content, err := ioutil.ReadFile(path)
	if err != nil {
		return nil, fmt.Errorf("unable to  read values file")
	}
	data := make(map[string]interface{}, 0)
	if err := yaml.Unmarshal(content, &data); err != nil {
		return nil, fmt.Errorf("unable decode the values content")
	}
	return data, nil

}

func main() {

	templateFile := os.Args[1]
	data, err := readValues(os.Args[2])
	if err != nil {
		log.Fatal(err)
	}
	//log.Printf("Data map: %v\n", data)
	tmpl := template.New("patch-volume.tmpl")
	tmpl, err = tmpl.ParseFiles(templateFile)
	if err != nil {
		log.Fatal("Error Parsing template: ", err)
		return
	}
	err1 := tmpl.Execute(os.Stdout, data)
	if err1 != nil {
		log.Fatal("Error executing template: ", err1)

	}
}
