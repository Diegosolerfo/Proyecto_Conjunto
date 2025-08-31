document.addEventListener('DOMContentLoaded', () => {
    // Lógica para las Pestañas (Tabs) - Similar al admin
    const navItems = document.querySelectorAll('.seller-nav .nav-item');
    const tabContents = document.querySelectorAll('.tab-content');

    navItems.forEach(item => {
        item.addEventListener('click', () => {
            navItems.forEach(nav => nav.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));

            item.classList.add('active');
            const targetTab = item.dataset.tab;
            document.getElementById(targetTab).classList.add('active');
        });
    });

    // Lógica para Modales (Abrir/Cerrar) - Adaptado para el modal de factura
    const modalButtons = document.querySelectorAll('[data-target][data-action]');
    const invoiceModal = document.getElementById('invoice-modal');
    const closeButtons = document.querySelectorAll('.modal .close-button');
    const modalTitle = invoiceModal.querySelector('.modal-title');
    const invoiceForm = invoiceModal.querySelector('.seller-form');
    const invoiceStatusSelect = document.getElementById('invoice-status'); // Para habilitar/deshabilitar campos en modo vista

    modalButtons.forEach(button => {
        button.addEventListener('click', () => {
            const action = button.dataset.action; // 'create', 'edit', 'view'

            // Limpiar formulario y resetear estado
            invoiceForm.reset();
            modalTitle.textContent = ''; // Limpiar título
            document.getElementById('invoice-product-lines').innerHTML = ''; // Limpiar líneas de producto
            addProductLine(); // Añadir una línea de producto vacía por defecto
            updateInvoiceTotals(); // Recalcular totales

            // Habilitar todos los campos por defecto al abrir el modal, luego ajustar si es 'view'
            invoiceForm.querySelectorAll('input, select, textarea, .add-product-line, .remove-product-line').forEach(field => {
                field.removeAttribute('readonly');
                field.removeAttribute('disabled');
                field.style.pointerEvents = 'auto'; // Asegurar que los botones sean clicables
                if (field.classList.contains('btn-primary') || field.classList.contains('btn-secondary')) {
                     field.style.display = 'inline-flex'; // Mostrar botones de acción
                }
            });
            invoiceModal.querySelector('.form-actions button[type="submit"]').style.display = 'inline-flex'; // Mostrar botón Guardar

            if (action === 'create') {
                modalTitle.textContent = 'Nueva Factura';
                // Aquí podrías generar un número de factura (simulado)
                document.getElementById('invoice-number').value = 'TEMP-00' + Math.floor(Math.random() * 1000);
            } else if (action === 'edit') {
                modalTitle.textContent = 'Editar Factura';
                // En una aplicación real: cargar datos de la factura seleccionada
                // const row = button.closest('tr');
                // const invoiceId = row.cells[0].textContent; // Obtener ID de la factura
                // Llenar el formulario con los datos de 'invoiceId'
                // document.getElementById('invoice-client-name').value = 'Juan Pérez';
                // document.getElementById('invoice-date').value = '2025-06-27';
                // document.getElementById('invoice-number').value = invoiceId;
                // document.getElementById('invoice-status').value = 'Pagada';
                // populateProductLines(data.products); // Función para añadir líneas de producto cargadas
                // updateInvoiceTotals();
            } else if (action === 'view') {
                modalTitle.textContent = 'Detalles de Factura';
                // En una aplicación real: cargar datos de la factura seleccionada y deshabilitar campos
                // const row = button.closest('tr');
                // const invoiceId = row.cells[0].textContent;
                // document.getElementById('invoice-client-name').value = 'Juan Pérez';
                // document.getElementById('invoice-date').value = '2025-06-27';
                // document.getElementById('invoice-number').value = invoiceId;
                // document.getElementById('invoice-status').value = 'Pagada';
                // populateProductLines(data.products);
                // updateInvoiceTotals();

                // Deshabilitar todos los campos y ocultar botones de acción/adición
                invoiceForm.querySelectorAll('input, select, textarea').forEach(field => {
                    field.setAttribute('readonly', true);
                    field.setAttribute('disabled', true);
                });
                invoiceForm.querySelectorAll('.add-product-line, .remove-product-line').forEach(btn => {
                    btn.style.pointerEvents = 'none'; // Deshabilita clics sin deshabilitar el botón
                    btn.style.opacity = '0.5'; // Muestra que está deshabilitado
                    // Ocultar completamente: btn.style.display = 'none';
                });
                invoiceModal.querySelector('.form-actions button[type="submit"]').style.display = 'none'; // Ocultar botón Guardar
            }

            invoiceModal.style.display = 'block';
        });
    });

    closeButtons.forEach(button => {
        button.addEventListener('click', () => {
            button.closest('.modal').style.display = 'none';
        });
    });

    window.addEventListener('click', (event) => {
        if (event.target === invoiceModal) {
            invoiceModal.style.display = 'none';
        }
    });

    // Lógica para Añadir/Eliminar Líneas de Producto en el Formulario de Factura
    const productLinesContainer = document.getElementById('invoice-product-lines');
    const addProductLineBtn = invoiceModal.querySelector('.add-product-line');

    function addProductLine(productName = '', quantity = 1, unitPrice = 0) {
        const newRow = document.createElement('tr');
        newRow.classList.add('product-line');
        newRow.innerHTML = `
            <td>
                <select class="product-select" required>
                    <option value="">Seleccione Producto</option>
                    <option value="Café Colombia Supremo" data-price="25000">Café Colombia Supremo (500g)</option>
                    <option value="Cafetera Espresso" data-price="850000">Cafetera Espresso Clásica</option>
                    <option value="Molinillo Manual" data-price="120000">Molinillo Manual Premium</option>
                    <option value="Set Tazas Cappuccino" data-price="50000">Set Tazas Cappuccino (x2)</option>
                    </select>
            </td>
            <td><input type="number" class="quantity-input" min="1" value="${quantity}" required></td>
            <td><input type="text" class="unit-price-input" value="${unitPrice.toLocaleString('es-CO')}" readonly></td>
            <td><input type="text" class="line-total-input" value="0" readonly></td>
            <td><button type="button" class="btn btn-icon btn-delete remove-product-line"><i class="fas fa-trash-alt"></i></button></td>
        `;
        productLinesContainer.appendChild(newRow);

        // Pre-seleccionar producto si se proporciona
        const selectElement = newRow.querySelector('.product-select');
        if (productName) {
            selectElement.value = productName;
            // Disparar el evento change para actualizar precio y total
            selectElement.dispatchEvent(new Event('change'));
        }

        attachProductLineListeners(newRow);
    }

    function attachProductLineListeners(row) {
        const productSelect = row.querySelector('.product-select');
        const quantityInput = row.querySelector('.quantity-input');
        const unitPriceInput = row.querySelector('.unit-price-input');
        const lineTotalInput = row.querySelector('.line-total-input');
        const removeButton = row.querySelector('.remove-product-line');

        productSelect.addEventListener('change', () => {
            const selectedOption = productSelect.options[productSelect.selectedIndex];
            const price = parseFloat(selectedOption.dataset.price || 0);
            unitPriceInput.value = price.toLocaleString('es-CO'); // Formatear a moneda
            updateLineTotal(row);
        });

        quantityInput.addEventListener('input', () => updateLineTotal(row));

        removeButton.addEventListener('click', () => {
            if (productLinesContainer.children.length > 1) { // Asegurarse de que al menos una línea quede
                row.remove();
                updateInvoiceTotals();
            } else {
                alert('Debe haber al menos un producto en la factura.');
            }
        });

        // Asegurar que los valores iniciales se calculen
        updateLineTotal(row);
    }

    function updateLineTotal(row) {
        const productSelect = row.querySelector('.product-select');
        const quantity = parseFloat(row.querySelector('.quantity-input').value) || 0;
        const selectedOption = productSelect.options[productSelect.selectedIndex];
        const unitPrice = parseFloat(selectedOption.dataset.price || 0);

        const lineTotal = quantity * unitPrice;
        row.querySelector('.line-total-input').value = lineTotal.toLocaleString('es-CO');
        updateInvoiceTotals();
    }

    function updateInvoiceTotals() {
        let subtotal = 0;
        document.querySelectorAll('.product-line').forEach(row => {
            const lineTotal = parseFloat(row.querySelector('.line-total-input').value.replace(/\./g, '').replace(/,/g, '.')) || 0; // Limpiar formato de moneda
            subtotal += lineTotal;
        });

        const iva = subtotal * 0.19; // 19% de IVA
        const total = subtotal + iva;

        document.getElementById('invoice-subtotal').value = subtotal.toLocaleString('es-CO');
        document.getElementById('invoice-iva').value = iva.toLocaleString('es-CO');
        document.getElementById('invoice-total').value = total.toLocaleString('es-CO');
    }

    addProductLineBtn.addEventListener('click', () => addProductLine());

    // Lógica para botones de Eliminar (simulado) - Para filas de la tabla de facturas
    document.querySelectorAll('.btn-delete').forEach(button => {
        button.addEventListener('click', () => {
            if (confirm('¿Estás seguro de que quieres cancelar esta factura? Esta acción no se puede deshacer.')) {
                const row = button.closest('tr');
                if (row) {
                    row.remove();
                    alert('Factura eliminada/cancelada (simulado).');
                }
            }
        });
    });

    // Inicializar: Asegurar que el Dashboard sea la pestaña activa al cargar
    document.getElementById('dashboard').classList.add('active');
    document.querySelector('[data-tab="dashboard"]').classList.add('active');

    // Inicializar el modal de factura con una línea vacía al cargar la página por primera vez
    // (Esto es solo para asegurar que la primera vez que abras el modal, tenga una línea)
    // Normalmente, solo añadirías addProductLine() cuando abres el modal en modo "create"
    // addProductLine(); // Descomentar si quieres que siempre tenga una línea al cargar
});