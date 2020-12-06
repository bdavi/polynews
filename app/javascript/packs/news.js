// When an image fails to load, we don't want a broken image to display.
// So we hide the image header and show the text header.
const handleNewsImageLoadError = (element) => {
  const imageHeader = element.parentElement.parentElement;
  const textHeader = element.parentElement.parentElement.nextElementSibling;
  imageHeader.style.display = 'none';
  textHeader.style.display = 'block';
};

window.handleNewsImageLoadError = handleNewsImageLoadError;
