<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Administración | INNOVAR CAFÉ</title>
    <link rel="stylesheet" href="admin.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.7/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-LN+7fdVzj6u52u30Kp6M/trliBMCMKTyK833zpbD+pXdCLuTusPj697FH4R/5mcr" crossorigin="anonymous">
</head>
<body>
    <div class="admin-container">
        <aside class="sidebar">
            <div class="sidebar-header">
                <img src="../Imagenes/Logo_Admin.png" alt="Admin Logo" class="admin-logo">
                <h2>Administrador</h2>
            </div>
            <nav class="admin-nav">
                <ul>
                    <li class="nav-item active" data-tab="dashboard">
                        <i class="fas fa-tachometer-alt"></i> Dashboard
                    </li>
                    <li class="nav-item" data-tab="clientes">
                        <i class="fas fa-users"></i> Clientes
                    </li>
                    <li class="nav-item" data-tab="vendedores">
                        <i class="fas fa-user-tie"></i> Cajeros
                    </li>
                    <li class="nav-item" data-tab="productos">
                        <i class="fas fa-coffee"></i> Productos
                    </li>
                    <li class="nav-item" data-tab="ajustes">
                        <i class="fas fa-cogs"></i> Ajustes
                    </li>
                    <li class="nav-item">
                        <a href="Trabajo_clase.html"><i class="fas fa-arrow-alt-circle-left"></i> Volver a Tienda</a>
                    </li>
                </ul>
            </nav>
        </aside>

        <main class="admin-content">
            <header class="content-header">
                <h1>Panel de Administración</h1>
                <div class="user-info">
                    <span>Hola, Administrador</span>
                    <i class="fas fa-user-circle"></i>
                </div>
            </header>
            <?php
            include '../../Modelo/usuariodao.php';
            $usuariodao = new usuariodao();
            $datos = $usuariodao->panel_admin();
            //var_dump($usuariodao);
            $respuesta = $usuariodao->ver_usuarios();
            $respuesta_2 = $usuariodao->ver_usuarios_2();
            ?>
            <section id="dashboard" class="tab-content active">
                <div class="card-grid">
                    <div class="card dashboard-card">
                        <h3>Total Clientes</h3>
                        <p class="metric"><?php echo $datos['NUM_CLIENTES']; ?></p>
                        <i class="fas fa-users icon-overlay"></i>
                    </div>
                    <div class="card dashboard-card">
                        <h3>Productos en Stock</h3>
                        <p class="metric"><?php echo $datos['PRODUCTOS_STOCK']; ?></p>
                        <i class="fas fa-boxes icon-overlay"></i>
                    </div>
                    <div class="card dashboard-card">
                        <h3>Ventas Mes</h3>
                        <p class="metric"><?php echo $datos['VENTAS_MES']; ?></p>
                        <i class="fas fa-chart-line icon-overlay"></i>
                    </div>
                    <div class="card dashboard-card">
                        <h3>Deudas activas</h3>
                        <p class="metric"><?php echo $datos['DEUDAS']; ?></p>
                        <i class="fas fa-receipt icon-overlay"></i>
                    </div>
                </div>
                <div class="recent-activity card">
                    <h3>Actividad Reciente</h3>
                    <ul>
                        <li><span class="activity-time">Hace 5 min:</span> Nuevo cliente registrado - Juan Pérez.</li>
                        <li><span class="activity-time">Hace 30 min:</span> Producto "Café Colombia Supremo" actualizado.</li>
                        <li><span class="activity-time">Hace 1 hora:</span> Vendedor María García editó su perfil.</li>
                        <li><span class="activity-time">Ayer:</span> Eliminado producto "Tostadora Vieja".</li>
                    </ul>
                </div>
            </section>

            <section id="clientes" class="tab-content">
                <h2>Gestión de Clientes</h2>
                <div class="controls">
                    <button class="btn btn-primary" data-action="create" data-target="cliente-modal"><i class="fas fa-plus-circle"></i> Nuevo Cliente</button>
                    <div class="search-box">
                        <input type="text" placeholder="Buscar cliente...">
                        <i class="fas fa-search"></i>
                    </div>
                </div>
                <div class="table-responsive card">
                    
                    <table class="table table-bordered table-hover align-middle text-center">
                        <thead class="bg-success text-white">
                            <tr>
                                <th>Cedula</th>
                                <th>Nombre</th>
                                <th>Apellido</th>
                                <th>Correo</th>
                                <th>Telefono</th>
                                <th>Genero</th>
                                <th>Fecha Nacimiento</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            //var_dump($respuesta); 
                            foreach ($respuesta as $cliente) {
                            ?>
                            <form action="../../Controlador/controler_usuario.php" method="post">
                                <tr>
                                <td><input type="number" class="form-control" min="100000" max="99999999999" readonly name="cedula" value="<?php echo $cliente['CEDULA']; ?>"></td>
                                <td><input type="text" class="form-control " name="nombre" minlength="3" maxlength="25" value="<?php echo $cliente['NOMBRE']; ?>" required></td>
                                <td><input type="text" class="form-control " name="apellido" minlength="3" maxlength="25" value="<?php echo $cliente['APELLIDO']; ?>" required></td>
                                <td><input type="email" class="form-control" name="correo" maxlength="50" value="<?php echo $cliente['CORREO']; ?>" required></td>
                                <td><input type="number" class="form-control border" name="telefono" min="2000000000" max="3999999999" value="<?php echo $cliente['TELEFONO']; ?>" required></td>
                                <td>
                                    <select name="genero" id="genero" class="form-select" required>
                                        <option value="MASCULINO" <?php if($cliente['GENERO'] == 'MASCULINO') echo 'selected'; ?>>Masculino</option>
                                        <option value="FEMENINO" <?php if($cliente['GENERO'] == 'FEMENINO') echo 'selected'; ?>>Femenino</option>
                                        <option value="OTRO" <?php if($cliente['GENERO'] == 'OTRO') echo 'selected'; ?>>Otro</option>
                                    </select>
                                </td>
                                <td><input type="date" class="form-control" name="fecha_nacimiento" value="<?php echo $cliente['FECHA_NACIMIENTO']; ?>" required></td>
                                <td>
                                    <select name="estado" id="estado" class="form-select " required>
                                        <option value="ACTIVO" <?php if($cliente['ESTADO'] == 'ACTIVO') echo 'selected'; ?>>Activo</option>
                                        <option value="INACTIVO" <?php if($cliente['ESTADO'] == 'INACTIVO') echo 'selected'; ?>>Inactivo</option>
                                    </select>
                                </td>
                                <td>
                                        <button class="btn btn-icon btn-edit" name="accion" value="actualizar"><i class="fas fa-edit"></i></button>
                                        <button class="btn btn-icon" name="accion" value="eliminar"><i class="fas fa-trash-alt"></i></button>
                                </td>
                            </tr>
                            </form>
                            <?php
                            }
                            ?>
                            </tbody>
                    </table>
                </div>
            </section>

            <section id="vendedores" class="tab-content">
                <h2>Gestión de Cajeros</h2>
                <div class="controls">
                    <button class="btn btn-primary" data-action="create" data-target="cajero-modal"><i class="fas fa-user-plus"></i> Nuevo Cajero</button>
                    <div class="search-box">
                        <input type="text" placeholder="Buscar cajero...">
                        <i class="fas fa-search"></i>
                    </div>
                </div>
                <div class="table-responsive card">
                    <table class="table table-bordered table-hover align-middle text-center">
                        <thead class="bg-success text-white">
                            <tr>
                                <th>Cedula</th>
                                <th>Nombre</th>
                                <th>Apellido</th>
                                <th>Correo</th>
                                <th>Telefono</th>
                                <th>Genero</th>
                                <th>Fecha Nacimiento</th>
                                <th>Estado</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <?php
                            //var_dump($respuesta); 
                            foreach ($respuesta_2 as $cajero) {
                            ?>
                            <form action="../../Controlador/controler_usuario.php" method="post">
                                <tr>
                                <td><input type="number" class="form-control" min="100000" max="99999999999" readonly name="cedula" value="<?php echo $cajero['CEDULA']; ?>"></td>
                                <td><input type="text" class="form-control " name="nombre" minlength="3" maxlength="25" value="<?php echo $cajero['NOMBRE']; ?>" required></td>
                                <td><input type="text" class="form-control " name="apellido" minlength="3" maxlength="25" value="<?php echo $cajero['APELLIDO']; ?>" required></td>
                                <td><input type="email" class="form-control" name="correo" maxlength="50" value="<?php echo $cajero['CORREO']; ?>" required></td>
                                <td><input type="number" class="form-control border" name="telefono" min="2000000000" max="3999999999" value="<?php echo $cajero['TELEFONO']; ?>" required></td>
                                <td>
                                    <select name="genero" id="genero" class="form-select" required>
                                        <option value="MASCULINO" <?php if($cajero['GENERO'] == 'MASCULINO') echo 'selected'; ?>>Masculino</option>
                                        <option value="FEMENINO" <?php if($cajero['GENERO'] == 'FEMENINO') echo 'selected'; ?>>Femenino</option>
                                        <option value="OTRO" <?php if($cajero['GENERO'] == 'OTRO') echo 'selected'; ?>>Otro</option>
                                    </select>
                                </td>
                                <td><input type="date" class="form-control" name="fecha_nacimiento" value="<?php echo $cajero['FECHA_NACIMIENTO']; ?>" required></td>
                                <td>
                                    <select name="estado" id="estado" class="form-select " required>
                                        <option value="ACTIVO" <?php if($cajero['ESTADO'] == 'ACTIVO') echo 'selected'; ?>>Activo</option>
                                        <option value="INACTIVO" <?php if($cajero['ESTADO'] == 'INACTIVO') echo 'selected'; ?>>Inactivo</option>
                                    </select>
                                </td>
                                <td>
                                        <button class="btn btn-icon btn-edit" name="accion" value="actualizar"><i class="fas fa-edit"></i></button>
                                        <button class="btn btn-icon" name="accion" value="eliminar"><i class="fas fa-trash-alt"></i></button>
                                </td>
                            </tr>
                            </form>
                            <?php
                            }
                            ?>
                            </tbody>
                    </table>
                </div>
            </section>

            <section id="productos" class="tab-content">
                <h2>Gestión de Productos</h2>
                <div class="controls">
                    <button class="btn btn-primary" data-action="create" data-target="producto-modal"><i class="fas fa-mug-hot"></i> Nuevo Producto</button>
                    <div class="search-box">
                        <input type="text" placeholder="Buscar producto...">
                        <i class="fas fa-search"></i>
                    </div>
                </div>
                <div class="table-responsive card">
                    <table>
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nombre</th>
                                <th>Categoría</th>
                                <th>Precio</th>
                                <th>Stock</th>
                                <th>Acciones</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>301</td>
                                <td>Café Colombia Supremo 500g</td>
                                <td>Granos de Origen</td>
                                <td>$25.000</td>
                                <td>150</td>
                                <td>
                                    <button class="btn btn-icon btn-edit" data-action="edit" data-target="producto-modal"><i class="fas fa-edit"></i></button>
                                    <button class="btn btn-icon btn-delete"><i class="fas fa-trash-alt"></i></button>
                                </td>
                            </tr>
                            <tr>
                                <td>302</td>
                                <td>Cafetera Espresso Clásica</td>
                                <td>Máquinas de Café</td>
                                <td>$850.000</td>
                                <td>25</td>
                                <td>
                                    <button class="btn btn-icon btn-edit" data-action="edit" data-target="producto-modal"><i class="fas fa-edit"></i></button>
                                    <button class="btn btn-icon btn-delete"><i class="fas fa-trash-alt"></i></button>
                                </td>
                            </tr>
                            </tbody>
                    </table>
                </div>
            </section>

            <section id="ajustes" class="tab-content">
                <h2>Configuración del Sistema</h2>
                <div class="card">
                    <p>Aquí se configurarían opciones generales del sistema, notificaciones, roles de usuario, etc.</p>
                    <form class="admin-form">
                        <div class="form-group">
                            <label for="site_name">Nombre del Sitio:</label>
                            <input type="text" id="site_name" value="INNOVAR CAFÉ">
                        </div>
                        <div class="form-group">
                            <label for="currency">Moneda:</label>
                            <select id="currency">
                                <option value="COP">COP - Pesos Colombianos</option>
                                <option value="USD">USD - Dólar Estadounidense</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Guardar Ajustes</button>
                    </form>
                </div>
            </section>

        </main>
    </div>

    <div id="cliente-modal" class="modal">
        <div class="modal-content card">
            <span class="close-button">&times;</span>
            <h3 class="modal-title">Nuevo Cliente</h3>
            <form class="admin-form" action="../../Controlador/controler_usuario.php" method="post">
                <div class="form-group">
                    <label for="cliente-cedula">Cédula:</label>
                    <input type="text" id="cliente-cedula" name="cedula" required>
                </div>
                <div class="form-group">
                    <label for="cliente-nombre">Nombre:</label>
                    <input type="text" id="cliente-nombre" name="nombre" required>
                </div>
                <div class="form-group">
                    <label for="cliente-apellido">Apellido:</label>
                    <input type="text" id="cliente-apellido" name="apellido" required>
                </div>
                <div class="form-group">
                    <label for="cliente-clave">clave:</label>
                    <input type="text" id="cliente-clave" name="clave" required>
                </div>
                <div class="form-group">
                    <label for="cliente-email">Email:</label>
                    <input type="email" id="cliente-email" name="correo" required>
                </div>
                <div class="form-group">
                    <input type="hidden" id="cliente-email" name="tipo_usuario" value="CLIENTE" readonly>
                </div>
                <div class="form-group">
                    <input type="hidden" id="tipo_usuario" name="tipo_usuario" value="CLIENTE">
                </div>
                <div class="form-group">
                    <label for="cliente-telefono">Teléfono:</label>
                    <input type="tel" id="cliente-telefono" name="telefono">
                </div>
                <div class="form-group">
                    <label for="cliente-genero">Género:</label>
                    <select id="cliente-genero" name="genero">
                        <option value="masculino">Masculino</option>
                        <option value="femenino">Femenino</option>
                        <option selected value="otro">Otro</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="cliente-fecha-nacimiento">Fecha de Nacimiento:</label>
                    <input type="date" id="cliente-fecha-nacimiento" name="fecha_nacimiento">
                </div>
                <input type="hidden" name="accion" value="crear_usuario">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Guardar Cliente</button>
            </form>
        </div>
    </div>
    <div id="cajero-modal" class="modal">
        <div class="modal-content card">
            <span class="close-button">&times;</span>
            <h3 class="modal-title">Nuevo cajero</h3>
            <form class="admin-form" action="../../Controlador/controler_usuario.php" method="post">
                <div class="form-group">
                    <label for="cajero-cedula">Cédula:</label>
                    <input type="number" id="cajero-cedula" name="cedula" required>
                </div>
                <div class="form-group">
                    <label for="cajero-nombre">Nombre:</label>
                    <input type="text" id="cajero-nombre" name="nombre" required>
                </div>
                <div class="form-group">
                    <label for="cajero-apellido">Apellido:</label>
                    <input type="text" id="cajero-apellido" name="apellido" required>
                </div>
                <div class="form-group">
                    <label for="cajero-clave">Clave:</label>
                    <input type="text" id="cajero-clave" name="clave" required>
                </div>
                <div class="form-group">
                    <label for="cajero-email">Email:</label>
                    <input type="email" id="cajero-email" name="correo" required>
                </div>
                <div class="form-group">
                    <input type="hidden" id="tipo_usuario" name="tipo_usuario" value="CAJERO">
                </div>
                <div class="form-group">
                    <label for="cajero-telefono">Teléfono:</label>
                    <input type="number" id="cajero-telefono" name="telefono">
                </div>
                <div class="form-group">
                    <label for="cajero-genero">Género:</label>
                    <select id="cajero-genero" name="genero">
                        <option value="masculino">Masculino</option>
                        <option value="femenino">Femenino</option>
                        <option selected value="otro">Otro</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="cajero-fecha-nacimiento">Fecha de Nacimiento:</label>
                    <input type="date" id="cajero-fecha-nacimiento" name="fecha_nacimiento">
                </div>
                <input type="hidden" name="accion" value="crear_usuario">
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Guardar Cajero</button>
            </form>
        </div>
    </div>

    <div id="producto-modal" class="modal">
        <div class="modal-content card">
            <span class="close-button">&times;</span>
            <h3 class="modal-title">Nuevo Producto</h3>
            <form class="admin-form" method="post">
                <div class="form-group">
                    <label for="producto-nombre">Nombre:</label>
                    <input type="text" id="producto-nombre" name="nombre" required>
                </div>
                <div class="form-group">
                    <label for="producto-categoria">Categoría:</label>
                    <select id="producto-categoria" name="categoria" required>
                        <option value="">Seleccione</option>
                        <option value="Granos de Origen">Granos de Origen</option>
                        <option value="Máquinas de Café">Máquinas de Café</option>
                        <option value="Accesorios Barista">Accesorios Barista</option>
                        <option value="Cafés Especiales">Cafés Especiales</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="producto-precio">Precio:</label>
                    <input type="number" id="producto-precio" name="precio" step="1000" min="0" required>
                </div>
                <div class="form-group">
                    <label for="producto-stock">Stock:</label>
                    <input type="number" id="producto-stock" name="stock" min="0" required>
                </div>
                <div class="form-group">
                    <label for="producto-descripcion">Descripción:</label>
                    <textarea id="producto-descripcion" name="descripcion" rows="3"></textarea>
                </div>
                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Guardar Producto</button>
            </form>
        </div>
    </div>

    <script src="adm.js"></script>
</body>
</html>