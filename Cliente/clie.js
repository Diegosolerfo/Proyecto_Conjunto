document.addEventListener('DOMContentLoaded', () => {
    const cart = JSON.parse(localStorage.getItem('innovarCafeCart')) || []; // Cargar carrito desde Local Storage
    const cartCountSpan = document.getElementById('cart-count');
    const cartItemsContainer = document.getElementById('cart-items-container');
    const cartSubtotalSpan = document.getElementById('cart-subtotal');
    const cartIvaSpan = document.getElementById('cart-iva');
    const cartTotalSpan = document.getElementById('cart-total');
    const emptyCartMessage = document.querySelector('.empty-cart-message');

    const openCartBtn = document.getElementById('open-cart-btn');
    const closeCartBtn = document.getElementById('close-cart-btn');
    const cartSidebar = document.getElementById('cart-sidebar');
    const overlay = document.getElementById('overlay');

    const addProductBtns = document.querySelectorAll('.btn-add-to-cart');
    const menuToggle = document.querySelector('.menu-toggle');
    const mainNav = document.querySelector('.main-nav');

    // Función para formatear precios a moneda colombiana
    const formatCurrency = (amount) => {
        return new Intl.NumberFormat('es-CO', {
            style: 'currency',
            currency: 'COP',
            minimumFractionDigits: 0, // No mostrar decimales para COP
            maximumFractionDigits: 0
        }).format(amount);
    };

    // Abre/Cierra el menú de navegación en móviles
    menuToggle.addEventListener('click', () => {
        mainNav.classList.toggle('active');
    });


    // Renderizar el carrito
    function renderCart() {
        cartItemsContainer.innerHTML = ''; // Limpiar el contenedor actual

        if (cart.length === 0) {
            emptyCartMessage.style.display = 'block';
        } else {
            emptyCartMessage.style.display = 'none';
            cart.forEach(item => {
                const cartItemDiv = document.createElement('div');
                cartItemDiv.classList.add('cart-item');
                cartItemDiv.dataset.id = item.id; // Para identificar el producto

                cartItemDiv.innerHTML = `
                    <img src="images/${item.img || 'placeholder.jpg'}" alt="${item.name}" class="cart-item-img">
                    <div class="cart-item-details">
                        <h4>${item.name}</h4>
                        <p class="cart-item-price">${formatCurrency(item.price)} c/u</p>
                        <div class="cart-item-actions">
                            <input type="number" class="quantity-input" value="${item.quantity}" min="1">
                            <button class="remove-item-btn"><i class="fas fa-trash-alt"></i></button>
                        </div>
                    </div>
                `;
                cartItemsContainer.appendChild(cartItemDiv);

                // Añadir listeners para los cambios de cantidad y eliminación
                cartItemDiv.querySelector('.quantity-input').addEventListener('change', updateQuantity);
                cartItemDiv.querySelector('.remove-item-btn').addEventListener('click', removeItem);
            });
        }
        updateCartTotals();
        updateCartCount();
        saveCart(); // Guardar el carrito en Local Storage
    }

    // Añadir producto al carrito
    addProductBtns.forEach(button => {
        button.addEventListener('click', (e) => {
            const id = button.dataset.id;
            const name = button.dataset.name;
            const price = parseFloat(button.dataset.price);
            const img = button.dataset.img || getProductImage(id); // Obtener imagen por ID o usar un placeholder

            const existingItem = cart.find(item => item.id === id);

            if (existingItem) {
                existingItem.quantity++;
            } else {
                cart.push({ id, name, price, quantity: 1, img });
            }
            renderCart();
            openCart(); // Abrir el carrito automáticamente
            // Opcional: Mostrar una notificación "Producto añadido al carrito"
            alert('"' + name + '" añadido al carrito!');
        });
    });

    // Actualizar cantidad de un producto en el carrito
    function updateQuantity(e) {
        const id = e.target.closest('.cart-item').dataset.id;
        const newQuantity = parseInt(e.target.value);

        const item = cart.find(item => item.id === id);
        if (item && newQuantity >= 1) {
            item.quantity = newQuantity;
        }
        renderCart();
    }

    // Eliminar producto del carrito
    function removeItem(e) {
        const id = e.target.closest('.cart-item').dataset.id;
        const itemIndex = cart.findIndex(item => item.id === id);

        if (itemIndex > -1) {
            cart.splice(itemIndex, 1);
        }
        renderCart();
    }

    // Actualizar totales del carrito
    function updateCartTotals() {
        let subtotal = 0;
        cart.forEach(item => {
            subtotal += item.price * item.quantity;
        });

        const iva = subtotal * 0.19; // IVA del 19%
        const total = subtotal + iva;

        cartSubtotalSpan.textContent = formatCurrency(subtotal);
        cartIvaSpan.textContent = formatCurrency(iva);
        cartTotalSpan.textContent = formatCurrency(total);
    }

    // Actualizar contador del carrito en el encabezado
    function updateCartCount() {
        const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
        cartCountSpan.textContent = totalItems;
    }

    // Guardar carrito en Local Storage
    function saveCart() {
        localStorage.setItem('innovarCafeCart', JSON.stringify(cart));
    }

    // Abrir el carrito
    openCartBtn.addEventListener('click', (e) => {
        e.preventDefault(); // Evitar el comportamiento por defecto del enlace
        cartSidebar.classList.add('open');
        overlay.style.display = 'block';
    });

    // Cerrar el carrito
    closeCartBtn.addEventListener('click', () => {
        cartSidebar.classList.remove('open');
        overlay.style.display = 'none';
    });

    // Cerrar carrito al hacer clic en el overlay
    overlay.addEventListener('click', () => {
        cartSidebar.classList.remove('open');
        overlay.style.display = 'none';
    });

    // Simular función para obtener la imagen del producto (en un proyecto real, esto vendría de una base de datos)
    function getProductImage(productId) {
        const images = {
            '1': 'cafe_colombia_supremo.jpg',
            '2': 'cafetera_espresso.jpg',
            '3': 'molinillo_manual.jpg',
            '4': 'set_tazas_cappuccino.jpg'
            // Añade más mapeos de ID a nombres de archivo de imagen
        };
        return images[productId] || 'placeholder.jpg'; // Retorna imagen o una de reemplazo
    }

    // Evento de "Proceder al Pago" (simulado)
    const checkoutBtn = document.querySelector('.checkout-btn');
    checkoutBtn.addEventListener('click', () => {
        if (cart.length > 0) {
            alert('¡Gracias por tu compra en INNOVAR CAFÉ!\nTu pedido ha sido procesado (simulado).');
            cart.length = 0; // Vaciar el carrito
            renderCart();
            closeCart(); // Cerrar el carrito
            // En una aplicación real, aquí redirigirías a una página de confirmación
            // o a un portal de pago.
        } else {
            alert('Tu carrito está vacío. Agrega productos antes de proceder al pago.');
        }
    });

    // Inicializar el carrito al cargar la página
    renderCart();
});