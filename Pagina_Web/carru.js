document.addEventListener('DOMContentLoaded', () => {
    const carruselImagenes = document.querySelector('.carrusel-imagenes');
    const botones = document.querySelectorAll('.carrusel-btn');
    const puntosContenedor = document.querySelector('.carrusel-puntos');
    const imagenes = document.querySelectorAll('.carrusel-imagenes img');
    let indiceActual = 0;
    const totalImagenes = imagenes.length;

    // Crear puntos dinámicamente si no están ya en el HTML
    // (Este código asume que los puntos ya están en el HTML, pero podrías generarlos aquí)
    const puntos = [];
    for (let i = 0; i < totalImagenes; i++) {
        const punto = puntosContenedor.children[i]; // Asume que ya existen
        if (punto) {
            puntos.push(punto);
            punto.addEventListener('click', () => {
                moverASlide(i);
            });
        }
    }

    function actualizarCarrusel() {
        // Mueve el contenedor de imágenes horizontalmente
        const desplazamiento = -indiceActual * 100; // Cada imagen ocupa el 100% del ancho
        carruselImagenes.style.transform = `translateX(${desplazamiento}%)`;

        // Actualiza los puntos indicadores
        puntos.forEach((punto, index) => {
            if (index === indiceActual) {
                punto.classList.add('activo');
            } else {
                punto.classList.remove('activo');
            }
        });
    }

    function moverASlide(indice) {
        indiceActual = indice;
        actualizarCarrusel();
    }

    // Funcionalidad de los botones de navegación
    botones.forEach(boton => {
        boton.addEventListener('click', () => {
            if (boton.classList.contains('next')) {
                indiceActual = (indiceActual + 1) % totalImagenes; // Vuelve al inicio si llega al final
            } else if (boton.classList.contains('prev')) {
                indiceActual = (indiceActual - 1 + totalImagenes) % totalImagenes; // Vuelve al final si llega al inicio
            }
            actualizarCarrusel();
        });
    });

    // Opcional: Carrusel automático
    let intervaloCarrusel = setInterval(() => {
        indiceActual = (indiceActual + 1) % totalImagenes;
        actualizarCarrusel();
    }, 5000); // Cambia de slide cada 5 segundos

    // Pausar el carrusel automático al pasar el ratón por encima
    carruselImagenes.addEventListener('mouseenter', () => {
        clearInterval(intervaloCarrusel);
    });

    // Reanudar el carrusel automático al quitar el ratón
    carruselImagenes.addEventListener('mouseleave', () => {
        intervaloCarrusel = setInterval(() => {
            indiceActual = (indiceActual + 1) % totalImagenes;
            actualizarCarrusel();
        }, 5000);
    });

    // Inicializar el carrusel en el primer slide
    actualizarCarrusel();
});