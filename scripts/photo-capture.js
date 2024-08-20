document.addEventListener('DOMContentLoaded', function() {
    const captureButton = document.getElementById('captureButton');
    
    captureButton.addEventListener('click', function() {
        const scene = document.querySelector('a-scene').components.screenshot.getCanvas('perspective');
        const link = document.createElement('a');
        link.href = scene.toDataURL('image/png');
        link.download = 'ar-capture.png';
        link.click();
    });
});
