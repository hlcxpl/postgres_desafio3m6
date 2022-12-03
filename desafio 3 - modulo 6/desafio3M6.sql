create DATABASE desafio3_luis_sanchez_333;
create table usuarios(
    id serial,
    email varchar(50),
    nombre varchar(50),
    apellidos varchar(60),
    rol varchar(50)
);
insert INTO usuarios(email, nombre, apellidos, rol)
values (
        'luis@gmail.com',
        'luis',
        'sanchez',
        'administrador'
    );
insert INTO usuarios(email, nombre, apellidos, rol)
values (
        'cristian@gmail.com',
        'cristian',
        'foundes',
        'usuario'
    );
insert INTO usuarios(email, nombre, apellidos, rol)
values (
        'eugenio@gmail.com',
        'eugenio',
        'lopez',
        'usuario'
    );
insert INTO usuarios(email, nombre, apellidos, rol)
values ('peter@gmail.com', 'peter', 'pan', 'usuario');
insert INTO usuarios(email, nombre, apellidos, rol)
values ('james@gmail.com', 'james', 'bon', 'usuario');
create table posts(
    id serial,
    titulo varchar(50),
    contenido text,
    fecha_creacion timestamp,
    fecha_actualizacion timestamp,
    destacado boolean,
    usuario_id bigint
);
insert INTO posts(
        titulo,
        contenido,
        fecha_creacion,
        fecha_actualizacion,
        destacado,
        usuario_id
    )
values (
        'titulo1',
        'lorem ipsun dolom in the name of jesus amen',
        '05-10-2022 12:00:15',
        '05-12-2022 1:10:15',
        true,
        1
    );
insert INTO posts(
        titulo,
        contenido,
        fecha_creacion,
        fecha_actualizacion,
        destacado,
        usuario_id
    )
values (
        'titulo2',
        'lorem ipsun dolom in the name of jesus amen',
        '02-11-2022 12:00:15',
        '10-12-2022 1:20:17',
        true,
        1
    );
insert INTO posts(
        titulo,
        contenido,
        fecha_creacion,
        fecha_actualizacion,
        destacado,
        usuario_id
    )
values (
        'titulo3',
        'lorem ipsun dolom in the name of jesus amen',
        '04-11-2022 4:10:15',
        '11-12-2022 3:10:15',
        false,
        2
    );
insert INTO posts(
        titulo,
        contenido,
        fecha_creacion,
        fecha_actualizacion,
        destacado,
        usuario_id
    )
values (
        'titulo4',
        'lorem ipsun dolom in the name of jesus amen',
        '07-10-2022 8:00:15',
        '09-12-2022 5:15:18',
        false,
        3
    );
insert INTO posts(
        titulo,
        contenido,
        fecha_creacion,
        fecha_actualizacion,
        destacado
    )
values (
        'titulo5',
        'lorem ipsun dolom in the name of jesus amen',
        '31-8-2022 12:20:15',
        '31-12-2022 12:00:00',
        true
    );
create table comentarios(
    id serial,
    contenido text,
    fecha_creacion timestamp,
    usuario_id bigint,
    post_id bigint
);
insert INTO comentarios(
        contenido,
        fecha_creacion,
        usuario_id,
        post_id
    )
values (
        'hello world with postgres',
        '20-10-2022 5:20:00',
        1,
        1
    );
insert INTO comentarios(
        contenido,
        fecha_creacion,
        usuario_id,
        post_id
    )
values (
        'hello world with postgres',
        '11-09-2022 6:20:00',
        2,
        1
    );
insert INTO comentarios(
        contenido,
        fecha_creacion,
        usuario_id,
        post_id
    )
values (
        'hello world with postgres',
        '03-05-2022 6:20:00',
        3,
        1
    );
insert INTO comentarios(
        contenido,
        fecha_creacion,
        usuario_id,
        post_id
    )
values (
        'hello world with postgres',
        '10-09-2022 6:20:00',
        1,
        2
    );
insert INTO comentarios(
        contenido,
        fecha_creacion,
        usuario_id,
        post_id
    )
values (
        'hello world with postgres',
        '19-10-2022 6:20:00',
        2,
        2
    );
--consultas--
--1.--
select usuarios.nombre,
    usuarios.email,
    posts.titulo,
    posts.contenido
from usuarios
    inner join posts on usuarios.id = posts.usuario_id;
--2.--
select posts.id,
    posts.titulo,
    posts.contenido
from posts
    INNER JOIN usuarios ON usuarios.id = posts.usuario_id
    and usuarios.rol = 'administrador';
--3--
select usuarios.id,
    usuarios.email,
    count(posts.usuario_id)
from usuarios
    left join posts on usuarios.id = posts.usuario_id
group BY usuarios.id,
    usuarios.email;
--4--
select usuarios.email
from usuarios
    INNER JOIN (
        select usuario_id,
            count(posts.usuario_id) as cuenta
        from posts
        GROUP BY usuario_id
        ORDER BY cuenta DESC
        limit 1
    ) as themostposted on usuarios.id = themostposted.usuario_id;
--5--
SELECT max(posts.fecha_creacion),
    usuarios.nombre
from posts
    INNER JOIN usuarios ON usuarios.id = posts.usuario_id
GROUP BY usuarios.nombre;
--6--
select posts.titulo,
    posts.contenido
from posts
    INNER JOIN (
        select post_id,
            count(post_id) as cuenta
        from comentarios
        group by post_id
        ORDER BY cuenta DESC
        LIMIT 1
    ) as mostcomented on posts.id = mostcomented.post_id;
--7--
select posts.titulo,
    posts.contenido,
    comentarios.contenido,
    usuarios.email
from posts
    left join comentarios on posts.id = comentarios.post_id
    left JOIN usuarios ON usuarios.id = posts.usuario_id;
--8--
select comentarios.contenido,
    comentarios.usuario_id
from comentarios
    INNER JOIN (
        SELECT usuario_id,
            max(fecha_creacion) as ultima_fecha
        from comentarios
        group BY usuario_id
    ) as lastdate_each_user ON lastdate_each_user.ultima_fecha = comentarios.fecha_creacion;
--9--
select usuarios.email
from usuarios
    left join comentarios on usuarios.id = comentarios.usuario_id
group by usuarios.email
having count(comentarios.usuario_id) = 0;