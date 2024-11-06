# URL Shortener API

A URL Shortener API built with **Ruby on Rails**. This application provides URL shortening functionality, URL redirection, and a feature to view the top 100 most accessed URLs. The project demonstrates clean **Object-Oriented Programming (OOP)** principles, including **Service Objects** and **Background Jobs**.

## Features

- **Shorten URLs**: Accepts a long URL and returns a shortened version with a unique code.
- **Redirection**: Accessing the shortened URL will redirect to the original URL.
- **Top 100 URLs**: Provides an endpoint to retrieve the top 100 most accessed URLs.
- **Fetch Titles**: A background job fetches and stores the `<title>` of each shortened URL.
- **Database Seeder**: A Rake task to populate the database with sample URLs for testing and development.

## Project Setup

### Prerequisites

- **Ruby** 3.2.2+
- **Rails** 7.1.5+
- **PostgreSQL** as the default database

### Installation

1. **Clone the repository**:

   ```bash
   git clone https://github.com/yourusername/url-shortener-api.git
   cd url-shortener-api
   ```

2. **Install dependencies**:

   ```bash
   bundle install
   ```

3. **Set up the database**:

   ```bash
   rails db:create
   rails db:migrate
   ```

4. **Run the server**:
   ```bash
   rails server
   ```

## API Endpoints

### 1. Shorten a URL

- **Endpoint**: `POST /api/v1/urls`
- **Description**: Takes a long URL and returns a shortened URL.
- **Parameters**: `original_url` (required)
- **Response**:
  ```json
  {
    "short_url": "http://localhost:3000/abc123"
  }
  ```

### 2. Redirect to Original URL

- **Endpoint**: `GET /:short_code`
- **Description**: Redirects to the original URL based on the provided `short_code`.
- **Example**: Accessing `http://localhost:3000/abc123` will redirect to the original URL, e.g., `https://example.com`.

### 3. View Top 100 URLs

- **Endpoint**: `GET /api/v1/top_urls`
- **Description**: Retrieves the top 100 most accessed URLs, sorted by access count.
- **Response**:
  ```json
  [
    {
      "short_code": "abc123",
      "original_url": "https://example.com",
      "title": "Example Website",
      "access": 150
    },
    ...
  ]
  ```

## Background Jobs

The application includes a background job that fetches the `<title>` of each URL:

- **Job**: `FetchTitleJob`
- **Description**: When a URL is shortened, the job fetches the `<title>` from the original URL's HTML and saves it to the database.
- **Queueing**: Jobs are processed asynchronously. Ensure you have a job processing system (like Sidekiq or Delayed Job) running in development and production environments.

## Database Seeding

You can populate the database with sample data using the provided Rake task.

### Running the Populate Rake Task

The Rake task creates 100 fake URLs with unique short codes, random access counts, and simulated titles.

1. **Run the task**:

   ```bash
   rails db:populate_urls
   ```

## Testing

To run tests for the application:

```bash
rspec
```

The test suite covers models, services, controllers, and background jobs to ensure functionality and code reliability.

## Code Quality and Clean OOP Practices

This application follows clean Object-Oriented Programming principles:

- **Service Objects**: Business logic for URL shortening is encapsulated in `UrlShortenerService`.
- **Background Jobs**: `FetchTitleJob` handles background processing for title fetching.
- **Encapsulation and Dependency Injection**: Services and jobs are modular and testable, ensuring loose coupling and reusability.

## License

This project is open-source and available under the [MIT License](LICENSE).

---
