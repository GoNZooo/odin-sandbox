package aos

import "core:fmt"
import "core:mem"
import "core:simd"
import "core:time"

Particle :: struct {
	x, y, z:    f32,
	vx, vy, vz: f32,
	mass:       f32,
}

// |---------------------------------------------------------------------------|
// |x, y, z, vx, vy, vz, mass, x, y, z, vx, vy, vz, mass, x, y, z, vx, vy, vz, mass |
// |x, y, z, vx, vy, vz, x, y, z, vx, vy, vz, x, y, z, vx, vy, vz, x, y, z, vx, vy, vz|

Particle_Arrays :: struct {
	position: [3]f32,
	velocity: [3]f32,
	mass:     f32,
}

Particle_No_Mass :: struct {
	x, y, z:    f32,
	vx, vy, vz: f32,
}

Particle_SOA :: struct {
	x:       [^]f32,
	y:       [^]f32,
	z:       [^]f32,
	vx:      [^]f32,
	vy:      [^]f32,
	vz:      [^]f32,
	mass:    [^]f32,
	_length: int,
}

Particle_Auto_SOA :: #soa[]Particle

run_normal :: proc(size: f32) -> (megabytes: f32, duration: time.Duration) {
	particle_count := int(size * f32(1_000_000))
	particles := make([]Particle, particle_count)
	defer delete(particles)

	for &p in particles {
		p.x = 1.0
		p.y = 2.0
		p.z = 3.0
		p.vx = 4.0
		p.vy = 5.0
		p.vz = 6.0
		p.mass = 7.0
	}

	start_time := time.tick_now()
	for &p in particles {
		p.x += p.vx
		p.y += p.vy
		p.z += p.vz
	}
	elapsed := time.tick_since(start_time)

	for p in particles {
		if p.x != 1.0 + 4.0 {
			panic("x")
		}
		if p.y != 2.0 + 5.0 {
			panic("y")
		}
		if p.z != 3.0 + 6.0 {
			panic("z")
		}
	}

	return f32(particle_count * size_of(Particle)) / mem.Megabyte, elapsed
}

run_arrays :: proc(size: f32) -> (megabytes: f32, duration: time.Duration) {
	particle_count := int(size * f32(1_000_000))
	particles := make([]Particle_Arrays, particle_count)
	defer delete(particles)

	for &p in particles {
		p.position.x = 1.0
		p.position.y = 2.0
		p.position.z = 3.0
		p.velocity.x = 4.0
		p.velocity.y = 5.0
		p.velocity.z = 6.0
		p.mass = 7.0
	}

	start_time := time.tick_now()
	for &p in particles {
		p.position.x += p.velocity.x
		p.position.y += p.velocity.y
		p.position.z += p.velocity.z
	}
	elapsed := time.tick_since(start_time)

	for p in particles {
		if p.position.x != 1.0 + 4.0 {
			panic("x")
		}
		if p.position.y != 2.0 + 5.0 {
			panic("y")
		}
		if p.position.z != 3.0 + 6.0 {
			panic("z")
		}
	}

	return f32(particle_count * size_of(Particle_Arrays)) / mem.Megabyte, elapsed
}

run_arrays_soa :: proc(size: f32) -> (megabytes: f32, duration: time.Duration) {
	particle_count := int(size * f32(1_000_000))
	particles: Particle_SOA
	particles.x = make([^]f32, particle_count)
	particles.y = make([^]f32, particle_count)
	particles.z = make([^]f32, particle_count)
	particles.vx = make([^]f32, particle_count)
	particles.vy = make([^]f32, particle_count)
	particles.vz = make([^]f32, particle_count)
	particles.mass = make([^]f32, particle_count)
	particles._length = particle_count
	defer free(particles.x)
	defer free(particles.y)
	defer free(particles.z)
	defer free(particles.vx)
	defer free(particles.vy)
	defer free(particles.vz)
	defer free(particles.mass)

	for i in 0 ..< particles._length {
		particles.x[i] = 1.0
		particles.y[i] = 2.0
		particles.z[i] = 3.0
		particles.vx[i] = 4.0
		particles.vy[i] = 5.0
		particles.vz[i] = 6.0
		particles.mass[i] = 7.0
	}

	start_time := time.tick_now()
	#no_bounds_check for i in 0 ..< particles._length {
		particles.x[i] += particles.vx[i]
		particles.y[i] += particles.vy[i]
		particles.z[i] += particles.vz[i]
	}
	elapsed := time.tick_since(start_time)

	for i in 0 ..< particles._length {
		if particles.x[i] != 1.0 + 4.0 {
			panic("x")
		}
		if particles.y[i] != 2.0 + 5.0 {
			panic("y")
		}
		if particles.z[i] != 3.0 + 6.0 {
			panic("z")
		}
	}

	size_in_megabytes := f32(particle_count * 7 * size_of(f32) + size_of(int)) / mem.Megabyte

	return size_in_megabytes, elapsed
}

run_arrays_soa_one_by_one :: proc(size: f32) -> (megabytes: f32, duration: time.Duration) {
	particle_count := int(size * f32(1_000_000))
	particles: Particle_SOA
	particles.x = make([^]f32, particle_count)
	particles.y = make([^]f32, particle_count)
	particles.z = make([^]f32, particle_count)
	particles.vx = make([^]f32, particle_count)
	particles.vy = make([^]f32, particle_count)
	particles.vz = make([^]f32, particle_count)
	particles.mass = make([^]f32, particle_count)
	particles._length = particle_count
	defer free(particles.x)
	defer free(particles.y)
	defer free(particles.z)
	defer free(particles.vx)
	defer free(particles.vy)
	defer free(particles.vz)
	defer free(particles.mass)

	for i in 0 ..< particles._length {
		particles.x[i] = 1.0
		particles.y[i] = 2.0
		particles.z[i] = 3.0
		particles.vx[i] = 4.0
		particles.vy[i] = 5.0
		particles.vz[i] = 6.0
		particles.mass[i] = 7.0
	}

	start_time := time.tick_now()
	#no_bounds_check for i in 0 ..< particles._length {
		particles.x[i] += particles.vx[i]
	}
	#no_bounds_check for i in 0 ..< particles._length {
		particles.y[i] += particles.vy[i]
	}
	#no_bounds_check for i in 0 ..< particles._length {
		particles.z[i] += particles.vz[i]
	}
	elapsed := time.tick_since(start_time)

	for i in 0 ..< particles._length {
		if particles.x[i] != 1.0 + 4.0 {
			panic("x")
		}
		if particles.y[i] != 2.0 + 5.0 {
			panic("y")
		}
		if particles.z[i] != 3.0 + 6.0 {
			panic("z")
		}
	}

	size_in_megabytes := f32(particle_count * 7 * size_of(f32) + size_of(int)) / mem.Megabyte

	return size_in_megabytes, elapsed
}

run_arrays_soa_simd :: proc(size: f32) -> (megabytes: f32, duration: time.Duration) {
	particle_count := int(size * f32(1_000_000))
	particles: Particle_SOA
	particles.x = make([^]f32, particle_count)
	particles.y = make([^]f32, particle_count)
	particles.z = make([^]f32, particle_count)
	particles.vx = make([^]f32, particle_count)
	particles.vy = make([^]f32, particle_count)
	particles.vz = make([^]f32, particle_count)
	particles.mass = make([^]f32, particle_count)
	particles._length = particle_count
	defer free(particles.x)
	defer free(particles.y)
	defer free(particles.z)
	defer free(particles.vx)
	defer free(particles.vy)
	defer free(particles.vz)
	defer free(particles.mass)

	for i in 0 ..< particles._length {
		particles.x[i] = 1.0
		particles.y[i] = 2.0
		particles.z[i] = 3.0
		particles.vx[i] = 4.0
		particles.vy[i] = 5.0
		particles.vz[i] = 6.0
		particles.mass[i] = 7.0
	}

	start_time := time.tick_now()
	STEP :: 64
	#no_bounds_check for i := 0; i < particles._length; i += STEP {
		end_index := i + STEP > particles._length ? particles._length : i + STEP
		slice := particles.x[i:end_index]
		if len(slice) < STEP {
			for j in i ..< particles._length {
				particles.x[j] += particles.vx[j]
				particles.y[j] += particles.vy[j]
				particles.z[j] += particles.vz[j]
			}

			break
		}

		xs := simd.from_slice(#simd[STEP]f32, particles.x[i:end_index])
		vxs := simd.from_slice(#simd[STEP]f32, particles.vx[i:end_index])
		xs = simd.add(xs, vxs)
		xs_array := simd.to_array(xs)
		copy(particles.x[i:end_index], xs_array[:])

		ys := simd.from_slice(#simd[STEP]f32, particles.y[i:end_index])
		vys := simd.from_slice(#simd[STEP]f32, particles.vy[i:end_index])
		ys = simd.add(ys, vys)
		ys_array := simd.to_array(ys)
		copy(particles.y[i:end_index], ys_array[:])

		zs := simd.from_slice(#simd[STEP]f32, particles.z[i:end_index])
		vzs := simd.from_slice(#simd[STEP]f32, particles.vz[i:end_index])
		zs = simd.add(zs, vzs)
		zs_array := simd.to_array(zs)
		copy(particles.z[i:end_index], zs_array[:])
	}
	elapsed := time.tick_since(start_time)

	size_in_megabytes := f32(particle_count * size_of(Particle_SOA)) / mem.Megabyte

	for i in 0 ..< particles._length {
		if particles.x[i] != 1.0 + 4.0 {
			panic("x")
		}
		if particles.y[i] != 2.0 + 5.0 {
			panic("y")
		}
		if particles.z[i] != 3.0 + 6.0 {
			panic("z")
		}
	}

	return size_in_megabytes, elapsed
}

run_arrays_auto_soa :: proc(size: f32) -> (megabytes: f32, duration: time.Duration) {
	particle_count := int(size * f32(1_000_000))
	particles := make_soa(Particle_Auto_SOA, particle_count)
	defer delete_soa(particles)

	for &p in particles {
		p.x = 1.0
		p.y = 2.0
		p.z = 3.0
		p.vx = 4.0
		p.vy = 5.0
		p.vz = 6.0
		p.mass = 7.0
	}

	start_time := time.tick_now()
	for &p in particles {
		p.x += p.vx
		p.y += p.vy
		p.z += p.vz
	}
	elapsed := time.tick_since(start_time)

	for p in particles {
		if p.x != 1.0 + 4.0 {
			panic("x")
		}
		if p.y != 2.0 + 5.0 {
			panic("y")
		}
		if p.z != 3.0 + 6.0 {
			panic("z")
		}
	}

	size_in_megabytes := f32(particle_count * 7 * size_of(f32) + size_of(int)) / mem.Megabyte

	return size_in_megabytes, elapsed
}

run_no_mass :: proc(size: f32) -> (megabytes: f32, duration: time.Duration) {
	particle_count := int(size * f32(1_000_000))
	particles := make([]Particle_No_Mass, particle_count)
	defer delete(particles)

	for &p in particles {
		p.x = 1.0
		p.y = 2.0
		p.z = 3.0
		p.vx = 4.0
		p.vy = 5.0
		p.vz = 6.0
	}

	start_time := time.tick_now()
	for &p in particles {
		p.x += p.vx
		p.y += p.vy
		p.z += p.vz
	}
	elapsed := time.tick_since(start_time)

	for p in particles {
		if p.x != 1.0 + 4.0 {
			panic("x")
		}
		if p.y != 2.0 + 5.0 {
			panic("y")
		}
		if p.z != 3.0 + 6.0 {
			panic("z")
		}
	}

	return f32(particle_count * size_of(Particle_No_Mass)) / mem.Megabyte, elapsed
}

run_suite :: proc(
	name: string,
	run_proc: proc(size: f32) -> (megabytes: f32, duration: time.Duration),
) {
	fmt.printf("=== %s ===\n", name)
	for size in SIZES {
		megabytes, duration := run_proc(size)
		fmt.printf("%0.1f million particles (%0.2f MB):\t%v\n", size, megabytes, duration)
	}
	fmt.printf("\n")
}

SIZES :: [?]f32{0.1, 1, 10, 100}

main :: proc() {
	// run_suite("Normal", run_normal)
	// run_suite("Arrays", run_arrays)
	// run_suite("No Mass", run_no_mass)
	run_suite("Arrays SOA", run_arrays_soa)
	run_suite("Arrays SOA one-by-one", run_arrays_soa_one_by_one)
	// run_suite("Arrays Auto SOA", run_arrays_auto_soa)
	// run_suite("Arrays SOA SIMD", run_arrays_soa_simd)
}

check_results :: proc(particles: Particle_SOA, particle_count: int) {
	for i in 0 ..< particle_count {
		if particles.x[i] != 1.0 + 4.0 {
			panic("x")
		}
		if particles.y[i] != 2.0 + 5.0 {
			panic("y")
		}
		if particles.z[i] != 3.0 + 6.0 {
			panic("z")
		}
	}
}
