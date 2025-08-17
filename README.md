# Home Assistant Add-on: HTML-to-Image (H2I)

This Home Assistant add-on runs the `bybetas/h2i` service, which provides a simple, local API to convert HTML into images. It's designed to be used by other services on your network, such as n8n, for generating dynamic images from HTML code.

## Installation

1.  Add this repository URL to your Home Assistant Supervisor Add-on Store:
    `https://github.com/guiman87/addon-h2i`
2.  Install the **HTML-to-Image (H2I)** add-on.
3.  In the add-on's **Configuration** tab, set a host port (e.g., `5005`) for the service.
4.  Start the add-on.

## Usage

The add-on exposes an HTTP endpoint on the port you configure. You can send a `POST` request with a JSON body containing your HTML, and it will return a JPG image.

**Example `curl` command:**

```bash
curl -X POST \
  http://homeassistant.local:5005 \
  -H 'Content-Type: application/json' \
  -d '{"html": "<html><body><h1>Hello, World!</h1></body></html>"}' \
  --output my-image.jpg
```
