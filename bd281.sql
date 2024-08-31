SELECT * FROM envio


-- Create the database
CREATE DATABASE IF NOT EXISTS artesania_ecommerce;
USE artesania_ecommerce;

-- Table COMUNIDAD
CREATE TABLE COMUNIDAD (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Ubicacion VARCHAR(255) NOT NULL,
    Latitud DECIMAL(9, 6),  -- Coordenada latitudinal
    Longitud DECIMAL(9, 6), -- Coordenada longitudinal
    Fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Table ROL for managing user roles
CREATE TABLE ROL (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL UNIQUE,
    Descripcion TEXT
);

-- Initial population of the ROL table
INSERT INTO ROL (Nombre) VALUES ('ARTESANO'), ('CLIENTE'), ('DELIVERY'), ('ADMINISTRADOR');

-- Table USUARIO
CREATE TABLE USUARIO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Correo_electronico VARCHAR(100) UNIQUE NOT NULL,
    Telefono VARCHAR(20),
    Contrasena VARCHAR(255) NOT NULL,
    ID_Rol INT NOT NULL,
    Direccion TEXT,
    Fecha_registro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Estado ENUM('ACTIVO', 'INACTIVO', 'SUSPENDIDO') DEFAULT 'INACTIVO',
    Ultima_conexion DATETIME,
    ID_Comunidad INT,
    FOREIGN KEY (ID_Rol) REFERENCES ROL(ID) ON DELETE RESTRICT,
    FOREIGN KEY (ID_Comunidad) REFERENCES COMUNIDAD(ID) ON DELETE SET NULL
);

-- Table CATEGORIA
CREATE TABLE CATEGORIA (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(50) NOT NULL,
    Descripcion TEXT
);

-- Table PRODUCTO
CREATE TABLE PRODUCTO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Nombre VARCHAR(100) NOT NULL,
    Descripcion TEXT,
    Fecha_creacion DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Fecha_actualizacion DATETIME ON UPDATE CURRENT_TIMESTAMP
);

-- Table TIENE
CREATE TABLE TIENE_PRODUCTO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Precio DECIMAL(10, 2) NOT NULL,---quitarlo
    Stock INT NOT NULL,
    Disponibilidad BOOLEAN DEFAULT TRUE,
    ID_Artesano INT,
    ID_Producto INT,
    Imagen_URL VARCHAR(255),
    FOREIGN KEY (ID_Artesano) REFERENCES USUARIO(ID) ON DELETE SET NULL,  -- Set NULL if artesano is deleted
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID) ON DELETE SET NULL -- Set NULL if community is deleted
);
-- Table TRANSPORTErol
CREATE TABLE TRANSPORTE (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Tipo ENUM('MOTO', 'BICICLETA', 'CAMION', 'COCHE', 'FURGONETA') NOT NULL,
    Descripcion TEXT,
    Costo_por_km DECIMAL(10, 2) NOT NULL,
    Capacidad DECIMAL(10, 2) NOT NULL,
    Estado ENUM('DISPONIBLE', 'EN USO', 'EN MANTENIMIENTO') DEFAULT 'DISPONIBLE'
);

-- Table COMPRA
CREATE TABLE COMPRA (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Estado ENUM('PENDIENTE', 'EN PROCESO', 'ENVIADO', 'ENTREGADO', 'CANCELADO') DEFAULT 'PENDIENTE',
    ID_Cliente INT NOT NULL,
    Total DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES USUARIO(ID) ON DELETE RESTRICT -- Prevent deleting user if they have orders
);

-- Table DETALLE_COMPRA
CREATE TABLE DETALLE_COMPRA (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_COMPRA INT NOT NULL,
    ID_PRODUCTO INT NOT NULL,
    ID_Artesano INT,
    Cantidad INT NOT NULL,
    Subtotal DECIMAL(10, 2) GENERATED ALWAYS AS (Cantidad * Precio) STORED,
    FOREIGN KEY (ID_COMPRA) REFERENCES COMPRA(ID) ON DELETE CASCADE, -- Delete order details if order is deleted
    FOREIGN KEY (ID_PRODUCTO) REFERENCES PRODUCTO(ID) ON DELETE RESTRICT -- Prevent deleting products if they have been ordered,
    FOREIGN KEY (ID_Artesano) REFERENCES USUARIO(ID) ON DELETE SET NULL,  -- Set NULL if artesano is deleted
);

-- Corrected Table ENVIO
CREATE TABLE ENVIO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_Compra INT NOT NULL,
    ID_Delivery INT,
    ID_Transporte INT,
    Comunidad_Origen INT, -- Changed from NOT NULL to allow NULL
    Direccion_Destino TEXT NOT NULL,
    Fecha_Envio DATE NOT NULL,
    Fecha_Entrega DATE,
    Estado ENUM('PREPARANDO', 'EN TRANSITO', 'ENTREGADO') DEFAULT 'PREPARANDO',
    Distancia DECIMAL(10, 2),
    Costo_envio DECIMAL(10, 2),
    FOREIGN KEY (ID_Compra) REFERENCES COMPRA(ID) ON DELETE CASCADE, -- Delete shipment if order is deleted
    FOREIGN KEY (ID_Delivery) REFERENCES USUARIO(ID) ON DELETE SET NULL, -- Set NULL if delivery user is deleted
    FOREIGN KEY (ID_Transporte) REFERENCES TRANSPORTE(ID) ON DELETE SET NULL, -- Set NULL if transport is deleted
    FOREIGN KEY (Comunidad_Origen) REFERENCES COMUNIDAD(ID) ON DELETE SET NULL -- Set NULL if community is deleted
);

-- Table PAGO
CREATE TABLE PAGO (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Fecha DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    Metodo_pago ENUM('TARJETA', 'TRANSFERENCIA', 'EFECTIVO', 'QR') NOT NULL,
    Estado ENUM('PENDIENTE', 'COMPLETADO', 'FALLIDO') DEFAULT 'PENDIENTE',
    ID_Cliente INT NOT NULL,
    ID_COMPRA INT NOT NULL,
    FOREIGN KEY (ID_Cliente) REFERENCES USUARIO(ID) ON DELETE RESTRICT, -- Prevent deleting user if they have payments
    FOREIGN KEY (ID_COMPRA) REFERENCES COMPRA(ID) ON DELETE CASCADE -- Delete payment if order is deleted
);

-- Table VALORACION
CREATE TABLE VALORACION (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_Usuario INT, -- Changed from NOT NULL to allow NULL
    ID_Producto INT NOT NULL,
    Puntuacion INT NOT NULL CHECK (Puntuacion BETWEEN 1 AND 5),
    Comentario TEXT,
    Fecha DATE NOT NULL,
    FOREIGN KEY (ID_Usuario) REFERENCES USUARIO(ID) ON DELETE SET NULL, -- Set NULL if user is deleted
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID) ON DELETE CASCADE -- Delete rating if product is deleted
);

-- Table for managing multiple categories per product
CREATE TABLE PRODUCTO_CATEGORIA (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    ID_Producto INT NOT NULL,
    ID_Categoria INT NOT NULL,
    FOREIGN KEY (ID_Producto) REFERENCES PRODUCTO(ID) ON DELETE CASCADE, -- Delete relation if product is deleted
    FOREIGN KEY (ID_Categoria) REFERENCES CATEGORIA(ID) ON DELETE CASCADE -- Delete relation if category is deleted
);

-- table informacion
CREATE TABLE INFORMACION (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    VISION TEXT,
    MISION TEXT,
    OBJETIVO TEXT,
);