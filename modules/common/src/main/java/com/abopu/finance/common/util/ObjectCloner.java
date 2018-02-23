package com.abopu.finance.common.util;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;

/**
 * @author Sarah Skanes
 * @created May 14, 2017.
 */
public final class ObjectCloner {

	@SuppressWarnings("unchecked")
	public static <T extends Serializable> T clone(T object) throws IOException {
		try {
			byte[] objectBytes;
			try (ByteArrayOutputStream baos = new ByteArrayOutputStream();
					 ObjectOutputStream oos = new ObjectOutputStream(baos)) {
				oos.writeObject(object);
				objectBytes = baos.toByteArray();
			}

			try (ByteArrayInputStream bais = new ByteArrayInputStream(objectBytes);
					 ObjectInputStream ois = new ObjectInputStream(bais)) {
				return (T) ois.readObject();
			}
		} catch (Exception e) {
			throw new IOException("Error cloning object.", e);
		}
	}
}
