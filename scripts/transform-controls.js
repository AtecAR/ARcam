AFRAME.registerComponent('transform-controls', {
    init: function () {
        const el = this.el;
        
        // 初期のモデルのスケール、ポジション、ローテーションを保持
        const initialScale = el.getAttribute('scale');
        const initialPosition = el.getAttribute('position');
        const initialRotation = el.getAttribute('rotation');

        // 位置調整スライダーの作成
        createSlider('Position X', initialPosition.x, (value) => {
            el.object3D.position.x = value;
        });
        createSlider('Position Y', initialPosition.y, (value) => {
            el.object3D.position.y = value;
        });
        createSlider('Position Z', initialPosition.z, (value) => {
            el.object3D.position.z = value;
        });

        // 回転調整スライダーの作成
        createSlider('Rotation X', initialRotation.x, (value) => {
            el.object3D.rotation.x = THREE.Math.degToRad(value);
        });
        createSlider('Rotation Y', initialRotation.y, (value) => {
            el.object3D.rotation.y = THREE.Math.degToRad(value);
        });
        createSlider('Rotation Z', initialRotation.z, (value) => {
            el.object3D.rotation.z = THREE.Math.degToRad(value);
        });

        // スケール調整スライダーの作成
        createSlider('Scale', initialScale.x, (value) => {
            el.object3D.scale.set(value, value, value);
        });
    }
});

// スライダー作成関数
function createSlider(label, initialValue, onChange) {
    const container = document.createElement('div');
    container.style.position = 'absolute';
    container.style.top = '10px';
    container.style.right = '10px';
    container.style.marginBottom = '10px';
    container.style.backgroundColor = 'rgba(255, 255, 255, 0.7)';
    container.style.padding = '10px';
    container.style.borderRadius = '5px';
    container.style.zIndex = '10';

    const sliderLabel = document.createElement('label');
    sliderLabel.textContent = label;
    container.appendChild(sliderLabel);

    const slider = document.createElement('input');
    slider.type = 'range';
    slider.min = label.includes('Rotation') ? '-180' : '0';
    slider.max = label.includes('Rotation') ? '180' : '5';
    slider.value = initialValue;
    slider.step = '0.01';
    slider.style.width = '100%';
    slider.addEventListener('input', (event) => {
        onChange(parseFloat(event.target.value));
    });
    container.appendChild(slider);

    document.body.appendChild(container);
}
