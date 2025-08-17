# Home Assistant Add-on: HTML-to-Image (H2I)

## Overview

The HTML-to-Image (H2I) add-on provides a simple API to convert HTML code into images. This is useful for dynamic image generation, creating visual representations of data, or generating visual content for dashboards and notifications.

## Installation

Follow these steps to get the add-on installed on your system:

1. Navigate in your Home Assistant frontend to **Settings** -> **Add-ons** -> **Add-on store**.
2. Find the "HTML-to-Image (H2I)" add-on and click it.
3. Click on the "INSTALL" button.

## How to use

1. Start the add-on.
2. The API will be available at `http://homeassistant:5005` within your Home Assistant network (or the port you configured).
3. Send HTTP POST requests with HTML content to generate images.

## Configuration

Example add-on configuration:

```yaml
quality: 80
width: 800
height: 600
timeout: 30000
allow_external_access: true
```

### Option: `quality`

The `quality` option sets the JPEG compression quality of the generated images. The value must be between `1` and `100`, where higher values result in better image quality but larger file sizes.

### Option: `width`

Default width of the generated images in pixels. This can be overridden in individual API requests.

### Option: `height`

Default height of the generated images in pixels. This can be overridden in individual API requests.

### Option: `timeout`

Maximum time in milliseconds to wait for the HTML rendering to complete. Increase this value for complex HTML content that may take longer to render.

### Option: `allow_external_access`

Enables connections from outside your Home Assistant network. This is required if you want to access the API from external services.

## API Usage

### Basic Image Generation

**Endpoint**: `POST http://homeassistant:5005`

**Headers**:
```
Content-Type: application/json
```

**Request Body**:
```json
{
  "html": "<html><body><h1>Hello World</h1></body></html>"
}
```

The response will be the generated JPEG image.

### Advanced Options

You can override the default settings in your request:

```json
{
  "html": "<html><body><h1>Hello World</h1></body></html>",
  "width": 1200,
  "height": 800,
  "quality": 90
}
```

## Using with n8n

To use this add-on with n8n:

1. In your n8n workflow, add an HTTP Request node
2. Configure the node:
   - **Method**: POST
   - **URL**: `http://homeassistant:5005`
   - **Headers**: Content-Type: application/json
   - **Body**: JSON with HTML content
   - **Response Format**: File

## Troubleshooting

### Connection Issues

If you're having trouble connecting to the service:

1. Check that the add-on is running in Home Assistant
2. Use `homeassistant` as the hostname when connecting from other add-ons
3. If using the service from outside Home Assistant, make sure `allow_external_access` is set to `true`
4. Verify the port mapping in the add-on configuration

### Image Generation Problems

If images aren't generating correctly:

1. Start with simple HTML to test the service
2. Check if your HTML has external resources (images, fonts) that may not be accessible
3. Increase the timeout value for complex HTML
4. Check the add-on logs for any error messages

### Running Diagnostics

The add-on includes a diagnostic tool that can help identify issues:

1. Access the Home Assistant Supervisor
2. Go to the H2I add-on
3. Open the "Terminal" tab
4. Run: `h2i-diagnostics`
