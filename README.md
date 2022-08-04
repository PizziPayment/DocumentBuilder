# Pizzi document builder

A simple docker image to setup an environment to build document usually from
this [template](https://github.com/PizziPayment/TemplateForPDF).

- Volume:
    - `/source`: source of the document (root of the repo).

Can be run like so once the image is generated to build a document:
```bash
docker run  -v $(pwd):/source <image_id>
```
