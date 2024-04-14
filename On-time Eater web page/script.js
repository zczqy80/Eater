document.body.addEventListener('click', function() {
    const pages = document.querySelectorAll('.container');
    let currentIndex = 0;
    pages.forEach((page, index) => {
        if (!page.style.display || page.style.display !== 'none') {
            page.style.display = 'none';
            currentIndex = index + 1;
        }
    });

    if (currentIndex >= pages.length) {
        currentIndex = 0;
    }

    pages[currentIndex].style.display = 'flex';
});