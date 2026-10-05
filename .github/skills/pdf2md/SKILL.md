# PDF to Markdown with OCR Skill

This skill converts PDF files to Markdown using OCR to extract text from images within the PDF.

## Parameters

- `input_file` (required): Path to the input PDF file
- `output_file` (optional): Path for the output Markdown file (defaults to input filename with .md extension)

## Usage

Run this skill to convert a PDF to Markdown with OCR:

```
pdf2md --input_file "path/to/document.pdf" --output_file "path/to/output.md"
```

Or simply:

```
pdf2md "path/to/document.pdf"
```

The skill uses the `pdf2md` Docker container which:
1. Extracts text directly from the PDF using `pdftotext`
2. Extracts images from the PDF using `pdfimages`
3. Runs OCR on each image using `tesseract` to get text content
4. Generates a Markdown file with both sources of text

## Example

```bash
pdf2md "SmartCore_Project_Booklet_Styled_Shmuel_Shay_Ashkenazi.pdf"
```

This will create `SmartCore_Project_Booklet_Styled_Shmuel_Shay_Ashkenazi_OCR.md` in the same directory.