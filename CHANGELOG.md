# Changelog

## 1.1.1 (06.10.2025)

### Fixed

- Copying config to install dir path first installation

## 1.1.0 (29.12.2024)

### Feature

- Added possibility via config add other products to check BIOS versions

### Fixed

- Fixed url with required language

## 1.0.2 (6.1.2024)

### Fixed

- Fixed the situation when a product has multiple variants (e.g. https://www.asus.com/supportonly/un5401qa/helpdesk_bios/)

## 1.0.1 (25.12.2023)

### Fixed

- Usage `#!/usr/bin/env` instead of hardcoded path `bash/sh`
- Removed usage of odiapi as it returns product url which uses javascript
- Fixed when were returned multiple product urls