document.addEventListener('DOMContentLoaded', () => {
    // Lógica para las Pestañas (Tabs)
    const navItems = document.querySelectorAll('.sidebar .nav-item');
    const tabContents = document.querySelectorAll('.tab-content');

    navItems.forEach(item => {
        item.addEventListener('click', () => {
            // Remover 'active' de todos los items y contenidos
            navItems.forEach(nav => nav.classList.remove('active'));
            tabContents.forEach(content => content.classList.remove('active'));

            // Añadir 'active' al item clicado y su contenido correspondiente
            item.classList.add('active');
            const targetTab = item.dataset.tab;
            document.getElementById(targetTab).classList.add('active');
        });
    });

    // Lógica para Modales (Abrir/Cerrar)
    const modalButtons = document.querySelectorAll('[data-target][data-action]');
    const modals = document.querySelectorAll('.modal');
    const closeButtons = document.querySelectorAll('.modal .close-button');

    modalButtons.forEach(button => {
        button.addEventListener('click', () => {
            const modalId = button.dataset.target;
            const action = button.dataset.action; // 'create' o 'edit'
            const modal = document.getElementById(modalId);
            const modalTitle = modal.querySelector('.modal-title');

            if (modal) {
                // Actualizar el título del modal según la acción
                if (action === 'create') {
                    if (modalId === 'cliente-modal') modalTitle.textContent = 'Nuevo Cliente';
                    else if (modalId === 'vendedor-modal') modalTitle.textContent = 'Nuevo Vendedor';
                    else if (modalId === 'producto-modal') modalTitle.textContent = 'Nuevo Producto';
                    // Aquí podrías limpiar el formulario si es 'create'
                    modal.querySelector('form').reset();
                } else if (action === 'edit') {
                    if (modalId === 'cliente-modal') modalTitle.textContent = 'Editar Cliente';
                    else if (modalId === 'vendedor-modal') modalTitle.textContent = 'Editar Vendedor';
                    else if (modalId === 'producto-modal') modalTitle.textContent = 'Editar Producto';
                    // Aquí es donde en una aplicación real cargarías los datos para editar
                    // Ejemplo: const row = button.closest('tr');
                    // const id = row.cells[0].textContent;
                    // Llenar el formulario con datos existentes
                }

                modal.style.display = 'block';
            }
        });
    });

    closeButtons.forEach(button => {
        button.addEventListener('click', () => {
            button.closest('.modal').style.display = 'none';
        });
    });

    // Cerrar modal al hacer clic fuera
    window.addEventListener('click', (event) => {
        modals.forEach(modal => {
            if (event.target === modal) {
                modal.style.display = 'none';
            }
        });
    });

    // Lógica para botones de Eliminar (simulado)
    document.querySelectorAll('.btn-delete').forEach(button => {
        button.addEventListener('click', () => {
            if (confirm('¿Estás seguro de que quieres eliminar este elemento?')) {
                // En una aplicación real, aquí harías una llamada API para eliminar el elemento.
                // Por ahora, solo lo removemos visualmente (para demostración).
                const row = button.closest('tr');
                if (row) {
                    row.remove();
                    alert('Elemento eliminado (simulado).');
                }
            }
        });
    });

    // Asegurar que el Dashboard sea la pestaña activa al cargar
    document.getElementById('dashboard').classList.add('active');
    document.querySelector('[data-tab="dashboard"]').classList.add('active');
});