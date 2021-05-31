window.addEventListener('message', (event) => {
    if (event.data.type === 'open') {
        doOpen();
    }
});

function doOpen() {
    document.getElementsByTagName("body")[0].style.display = "block"
}