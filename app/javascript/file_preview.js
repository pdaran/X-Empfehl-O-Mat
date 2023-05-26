document.addEventListener("DOMContentLoaded", () => {
  const fileInput = document.getElementById("file-input");
  const previewContainer = document.getElementById("file-preview");

  fileInput.addEventListener("change", (event) => {
    const file = event.target.files[0];
    if (file) {
      const reader = new FileReader();

      reader.addEventListener("load", () => {
        const previewImage = document.createElement("img");
        previewImage.src = reader.result;
        previewImage.classList.add("preview-image"); // Add this line
        previewContainer.innerHTML = ""; // Clear previous contents
        previewContainer.appendChild(previewImage);
      });

      reader.readAsDataURL(file);
    } else {
      previewContainer.innerHTML = ""; // Clear the preview container
    }
  });
});
