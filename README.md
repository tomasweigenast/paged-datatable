
# Paged Data Table
Completely customisable and extensible data table which supports cursor and offset pagination out-of-the-box.

Designed to follow Google Material You style.

## Getting started
- [Setup](#setup)
	- [Setup widget](#setup)
	- [Configure columns](#configure-columns)
	- [Filters](#filters)
	- [Options](#options)
	- [Fetch data](#fetch-data)
	- [Controller](#controller)
- [Configuration](#configuration)
- [Theming](#theming)
- [Internationalization](#internationalization)
- [Contribute](#contribute)
## Setup
Everything you need is a **PagedDataTable\<T>** widget, which accepts a generic argument **T**, the type of object you will display in the data table.
After that, it only requires two arguments to work: **columns** and **resolvePage**.

### Configure columns
