const { PDFDocument, rgb, StandardFonts } = require('pdf-lib');
const fs = require('fs');

async function generatePDF(jsonData, outputFile) {
    // Create a new PDF Document
    const pdfDoc = await PDFDocument.create();

    // Add a page to the document
    const page = pdfDoc.addPage([595, 842]); // A4 size: 595x842 points

    // Load fonts
    const font = await pdfDoc.embedFont(StandardFonts.TimesRoman);

    // Add header
    page.drawText("Company Name", {
        x: 50,
        y: 800,
        size: 20,
        font,
        color: rgb(0, 0, 0),
    });
    page.drawText("Address: 123 Example Street", {
        x: 50,
        y: 780,
        size: 12,
        font,
        color: rgb(0, 0, 0),
    });

    // Add logo (optional: replace 'logo.png' with your logo path)
    const logoBytes = fs.readFileSync('logo.png');
    const logoImage = await pdfDoc.embedPng(logoBytes);
    page.drawImage(logoImage, {
        x: 400,
        y: 770,
        width: 100,
        height: 50,
    });

    // Add JSON content in the middle of the document
    const contentY = 600;
    const lineSpacing = 20;
    let currentY = contentY;

    Object.keys(jsonData).forEach((key) => {
        page.drawText(`${key}: ${jsonData[key]}`, {
            x: 50,
            y: currentY,
            size: 12,
            font,
            color: rgb(0, 0, 0),
        });
        currentY -= lineSpacing;
    });

    // Add footer
    page.drawText("© 2024 Company Name. All rights reserved.", {
        x: 50,
        y: 50,
        size: 10,
        font,
        color: rgb(0, 0, 0),
    });

    // Secure the PDF with an owner password
    // pdfDoc.encrypt({
    //     ownerPassword: 'owner-password', // Replace with your owner password
    //     permissions: {
    //         printing: 'highResolution',
    //         modifying: false,
    //         copying: false,
    //     },
    // });
    page.drawText('The Life of an Egg', { x: 60, y: 500, size: 50 })
    page.drawText('An Epic Tale of Woe', { x: 125, y: 460, size: 25 })
    
    // Set all available metadata fields on the PDFDocument. Note that these fields
    // are visible in the "Document Properties" section of most PDF readers.
    pdfDoc.setTitle('🥚 The Life of an Egg 🍳')
    pdfDoc.setAuthor('Humpty Dumpty')
    pdfDoc.setSubject('📘 An Epic Tale of Woe 📖')
    pdfDoc.setKeywords(['eggs', 'wall', 'fall', 'king', 'horses', 'men'])
    pdfDoc.setProducer('PDF App 9000 🤖')
    pdfDoc.setCreator('pdf-lib (https://github.com/Hopding/pdf-lib)')
    pdfDoc.setCreationDate(new Date())
    pdfDoc.setModificationDate(new Date())
    // Write the PDF to a file
    const pdfBytes = await pdfDoc.save();
    fs.writeFileSync(outputFile, pdfBytes);

    console.log("PDF generated successfully!");
}

// Example usage
const jsonData = {
    Name: "John Doe",
    Age: "30",
    Occupation: "Software Developer",
    Location: "New York",
};

generatePDF(jsonData, "output.pdf");