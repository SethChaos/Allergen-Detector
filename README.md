# Project Tools & API Reference

This repository documents the available tools and their usage.  
Each tool is defined with its parameters and expected behavior.

---

## 📦 Functions

### `graphic_art`
- **Description:** Calls an AI model to create or edit an image.
- **Parameters:**
  - `prompt`: Text description of the desired image.
  - `progression_text`: A 6–8 word creative message ending with ellipses.
  - `transparent_background`: Boolean for transparent background.

---

### `search_web`
- **Description:** Searches the web for fresh, accurate, authoritative information.
- **Parameters:**
  - `query`: Optimized search string.
  - `answers`: Optional, specify type of answers.

---

### `search_finance`
- **Description:** Retrieves financial information.
- **Parameters:**
  - `stockExchangePrefix`: Market code.
  - `tickerSymbol`: Asset symbol.
  - `intent`: Query intent (stock, crypto, etc.).
  - `fromCurrency`, `toCurrency`: Currency conversion.
  - `currencyExchangeAmount`: Numeric amount to convert.

---

### `memory_durable_fact`
- **Description:** Stores facts and information for future conversations.
- **Parameters:**
  - `fact`: Information to remember.
  - `category`, `category_value`: Optional categorization.

---

### `memory_force_delete_durable_fact`
- **Description:** Deletes stored facts permanently.
- **Parameters:**
  - `fact_to_delete`: Information to remove.
  - `user_message`: Acknowledgment message.
  - `error_message`: Message if fact not found.

---

### `canmore_create_textdoc`
- **Description:** Creates a new page based on user query.
- **Parameters:**
  - `body`: Full generated page content.
  - `title`: Concise page title.

---

### `execute_code_orchestration`
- **Description:** Executes Python code for visualization and plotting.
- **Parameters:**
  - `prompt`: Detailed task description.
  - `title`: Concise task summary.
  - `is_document_creation_request`: Boolean.

---

### `fetch_web_content`
- **Description:** Fetches and extracts content from a URL.
- **Parameters:**
  - `url`: User-provided URL.

---

### `generate_quiz`
- **Description:** Generates a set of tailored multiple-choice questions.

---

### `search_images`
- **Description:** Searches the web for relevant images.
- **Parameters:**
  - `query`: Search query.
  - `page`: Results page number.

---

### `search_personal_data`
- **Description:** Searches personal data sources (documents, events, contacts, emails, web history).
- **Parameters:** Multiple filtering options (query, artifacts, services, time ranges, etc.).

---

### `search_places`
- **Description:** Provides location-based information.
- **Parameters:**
  - `query`: Location search query.
  - `is_near_me`: Boolean for nearby search.

---

### `search_products`
- **Description:** Aggregates shopping results.
- **Parameters:**
  - `query`: Product search query.
  - `category`, `city`, `country`: Optional filters.

---

### `search_uploaded_documents`
- **Description:** Returns filenames and extracted text from uploaded documents.

---

### `search_videos`
- **Description:** Searches the web for relevant videos.
- **Parameters:**
  - `query`: Search query.
  - `page`: Results page number.

---

### `windows_get_file_content`
- **Description:** Retrieves content of a local file.
- **Parameters:**
  - `keyword`: Partial filename.
  - `fullPath`: Full file path.

---

### `windows_open_file`
- **Description:** Opens a specified file.
- **Parameters:**
  - `keyword`: Partial filename.
  - `fullPath`: Full file path.

---

### `windows_open_setting`
- **Description:** Opens a Windows settings page.
- **Parameters:**
  - `keyword`: Settings keyword (e.g., `display`, `network`).

---

### `windows_search_files`
- **Description:** Searches for files on the Windows PC.
- **Parameters:**
  - `keyword`: Partial filename.
  - `file_type`: Document or picture.
  - `start_at`, `end_at`: Date range.
  - `fullPath`: Full file path.

---

## 🔀 Multi Tool Use

Namespace: `multi_tool_use`

### `parallel`
- **Description:** Runs multiple tools simultaneously.
- **Parameters:**
  - `tool_uses`: List of tools with parameters.

---

## 📝 Notes
- Only tools in the **functions** namespace are permitted.
- Parameters must strictly follow each tool’s specification.
- Use `multi_tool_use.parallel` for concurrent execution when possible.
