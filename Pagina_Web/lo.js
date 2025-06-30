const usuarios = [
    {
        id: 1,
        nombre: "Administrador Principal",
        usuario: "1028942699",
        contrasena: "admin123",
        rol: "administrador",
        activo: true
    },
    {
        id: 2,
        nombre: "María Cliente",
        usuario: "maria",
        contrasena: "cliente123",
        rol: "cliente",
        activo: true
    },
    {
        id: 3,
        nombre: "Pedro Operador",
        usuario: "pedro",
        contrasena: "operador123",
        rol: "operador",
        activo: false
    },
    {
        id: 4,
        nombre: "Laura Invitada",
        usuario: "laura",
        contrasena: "invitada123",
        rol: "cliente",
        activo: true
    }
];

function logeo(){
    const loginForm = document.getElementById('form-logeo');
        const username = document.getElementById('nombre_usuario').value;
        const password = document.getElementById('contrasena').value;
        
        if (username == 'admin' && password === 'admin123') {
            window.location.href = 'adminis.html'; // Redirecciona a la página de administrador
        } else if (username === 'maria' && password === 'cliente123') {
            window.location.href = 'cliente.html'; // Redirecciona a la página de cliente
        } else if (username === 'pedro' && password === 'operador123') {
            window.location.href = 'vendedor.html'; // Redirecciona a la página de operador
        } else if (username === 'laura' && password === 'invitada123') {
            window.location.href = 'vendedor.html'; // Redirecciona a la página de operador
        } else {
            alert('Usuario o contraseña incorrectos.');
        }
   
}
