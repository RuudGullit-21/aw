
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Автотест = Истина;
		Возврат;
	КонецЕсли;
	
	Если НЕ Параметры.Свойство("ТС") Тогда
		Отказ = Истина;
		СтандартнаяОбработка = Ложь;
		Возврат;
	КонецЕсли;
	
	ТС = Параметры.ТС;
	
	ВводВЭксплуатацию_Организация = Параметры.Организация;
	ВводВЭксплуатацию_Подразделение = Параметры.Подразделение;
	ВводВЭксплуатацию_Колонна = Параметры.Колонна;

	Если ТС.Модель.НаличиеСпидометра Тогда
		ВводНачальныхПоказаний_НачальныйСпидометр = Параметры.НачальныйПробег;
	Иначе
		ВводНачальныхПоказаний_ПоказанияСчетчикаМоточасов = Параметры.НачальныйПробег;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВводВЭксплуатацию_Организация) Тогда
		Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
		ЗначениеНастройки = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, 
		"ОсновнаяОрганизация");
		Если ЗначениеЗаполнено(ЗначениеНастройки) Тогда
			Если ВводВЭксплуатацию_Организация <> ЗначениеНастройки Тогда
				ВводВЭксплуатацию_Организация = ЗначениеНастройки;
			КонецЕсли;
		Иначе
			ВводВЭксплуатацию_Организация = Справочники.Организации.ПустаяСсылка();
		КонецЕсли;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВводВЭксплуатацию_Подразделение) Тогда
		ВводВЭксплуатацию_Подразделение = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь, "ОсновноеПодразделениеОрганизации");
	КонецЕсли;
	
	Параметры_ГСМ = уатОбщегоНазначенияТиповые.ПолучитьЗначенияРеквизитов(
		уатОбщегоНазначенияТиповые.ПолучитьЗначениеРеквизита(ТС, "Модель"),"ОсновноеТопливо, НаличиеТопливногоБака");
		
	ВводОстатковГСМ_ГСМ    = Параметры_ГСМ.ОсновноеТопливо;

	ДатаВводаВЭксплуатацию = ?(ЗначениеЗаполнено(Параметры.ДатаВводаВЭксплуатацию), Параметры.ДатаВводаВЭксплуатацию, ТекущаяДата());

	ВводВЭксплуатацию_ДатаВвода      = ДатаВводаВЭксплуатацию;
	ВводНачальныхПоказаний_ДатаВвода = ДатаВводаВЭксплуатацию;
	ВводОстатковГСМ_ДатаВвода        = ДатаВводаВЭксплуатацию;
	
	Элементы.ВводНачальныхПоказаний_ПоказанияСчетчикаМоточасов.Видимость = НЕ ТС.Модель.НаличиеСпидометра;
	Элементы.ВводНачальныхПоказаний_НачальныйСпидометр.Видимость = ТС.Модель.НаличиеСпидометра;
	
	Если НЕ ПравоДоступа("Редактирование", Метаданные.Документы.уатВводВЭксплуатациюТСиОборудования) Тогда
		Элементы.ГруппаВводВЭксплуатацию.Доступность = Ложь;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Редактирование", Метаданные.Документы.уатВводНачальныхПоказаний) Тогда
		Элементы.ГруппаВводНачальныхПоказаний.Доступность = Ложь;
	КонецЕсли;
	
	Если НЕ ПравоДоступа("Редактирование", Метаданные.Документы.уатВводОстатковГСМ) 
		ИЛИ НЕ Параметры_ГСМ.НаличиеТопливногоБака Тогда
		Элементы.ГруппаВводОстатковГСМ.Доступность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Если Автотест Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если ВладелецФормы = Неопределено Тогда
		Отказ = Истина;
		ПоказатьПредупреждение(Неопределено, НСтр("en='Immediate opening for this object is prohibited!';ru='Непосредственное открытие для данного объекта запрещено!'"));
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВводОстатковГСМ_ГСМНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)

	СтандартнаяОбработка = Ложь;
	
	ДополнительныеПараметры = Новый Структура("ЗначениеГСМДоИзменения", ВводОстатковГСМ_ГСМ);
	ОписаниеОповещенияЗакр  = Новый ОписаниеОповещения("ОписаниеОповещенияВыбораГСМ", ЭтотОбъект, ДополнительныеПараметры);
	уатЗащищенныеФункцииКлиент.СписокГСМдляТС(ВводВЭксплуатацию_Организация, ТС,
		ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Топливо"),,,ОписаниеОповещенияЗакр);
		
КонецПроцедуры

// Подключаемый динамически обработчик оповещения
&НаКлиенте
Процедура ОписаниеОповещенияВыбораГСМ(Результат, ДопПараметры) Экспорт
	Если Результат <> Неопределено Тогда
		ВводОстатковГСМ_ГСМ = Результат;
		Если ДопПараметры.ЗначениеГСМДоИзменения <> Результат Тогда 
			Модифицированность = Истина;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВводОстатковГСМ_ГСМАвтоПодбор(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, Ожидание, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	мсвГруппДляОтбора = Новый Массив;
	мсвГруппДляОтбора.Добавить(ПредопределенноеЗначение("Перечисление.уатГруппыГСМ.Топливо"));
	ДопПараметры = Новый Структура("ТС, Организация", ТС, ВводВЭксплуатацию_Организация);
	ДанныеВыбора = уатГСМ.ПолучитьСписокАвтоподбораПоляГСМ(Текст, мсвГруппДляОтбора, ДопПараметры);

КонецПроцедуры

&НаКлиенте
Процедура ВводОстатковГСМ_ГСМОкончаниеВводаТекста(Элемент, Текст, ДанныеВыбора, ПараметрыПолученияДанных, СтандартнаяОбработка)
	ПараметрыПолученияДанных.СтрокаПоиска = "";
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВводВЭксплуатациюСоздать(Команда)
	ДокументСсылка = НайтиВводВЭксплуатацию(ТС);
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		СсылкаДокумент	 = Новый ФорматированнаяСтрока(Строка(ДокументСсылка),,,,ПолучитьНавигационнуюСсылку(ДокументСсылка));
		Содержимое		 = Новый ФорматированнаяСтрока(Нстр("ru = 'Документ был создан ранее:'") + " ");
		ПоказатьПредупреждение(,Новый ФорматированнаяСтрока(Содержимое, СсылкаДокумент));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВводВЭксплуатацию_ДатаВвода) Тогда
		ТекстНстр = Нстр("en = 'The field ""Date entered"" is not bound'; ru = 'Поле ""Дата ввода"" не запонено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНстр);
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВводВЭксплуатацию_Организация) Тогда
		ТекстНстр = Нстр("en = 'The field "" Organization "" is not bound'; ru = 'Поле ""Организация"" не запонено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНстр);
		Возврат;
	КонецЕсли;
	
	ВводВЭксплуатациюСоздатьСервер();
	
	Если СсылкаНаДокумент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаДокумент	 = Новый ФорматированнаяСтрока(Строка(СсылкаНаДокумент),,,,ПолучитьНавигационнуюСсылку(СсылкаНаДокумент));
	Содержимое		 = Новый ФорматированнаяСтрока(Нстр("en = 'The document was created:'; ru = 'Создан документ:'") + " ");
	ПоказатьПредупреждение(,Новый ФорматированнаяСтрока(Содержимое, СсылкаДокумент));
	
	мТС =Новый Массив();
	мТС.Добавить(ТС);
	Оповестить("ОбновитьФорму_МестонахождениеТС", , мТС);

КонецПроцедуры

&НаСервере
Процедура ВводВЭксплуатациюСоздатьСервер()
	Попытка
		ДокОбъект = Документы.уатВводВЭксплуатациюТСиОборудования.СоздатьДокумент();
		ДокОбъект.Дата          = ВводВЭксплуатацию_ДатаВвода;
		ДокОбъект.Организация   = ВводВЭксплуатацию_Организация;
		ДокОбъект.Подразделение = ВводВЭксплуатацию_Подразделение;
		ДокОбъект.Колонна       = ВводВЭксплуатацию_Колонна;
		ТекТС           = ДокОбъект.ТС.Добавить();
		ТекТС.ТС        = ТС;
		ТекТС.ДатаВвода = ВводВЭксплуатацию_ДатаВвода;
		Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
		ДокОбъект.Ответственный = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь,
				"ОсновнойОтветственный");
		
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		СсылкаНаДокумент = ДокОбъект.Ссылка;
		СсылкаДокумент	 = Новый ФорматированнаяСтрока(Строка(СсылкаНаДокумент),,,,ПолучитьНавигационнуюСсылку(СсылкаНаДокумент));
		Содержимое		 = Новый ФорматированнаяСтрока(Нстр("en = 'The document was created:'; ru = 'Создан документ:'") + " ");
		
		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = Новый ФорматированнаяСтрока(Содержимое, СсылкаДокумент);
		Сообщение.КлючДанных = СсылкаНаДокумент;
		Сообщение.Сообщить();
	
	Исключение
	КонецПопытки;
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиВводВЭксплуатацию(ТС)
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТС", ТС);
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	уатВводВЭксплуатациюТСиОборудованияТС.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.уатВводВЭксплуатациюТСиОборудования.ТС КАК уатВводВЭксплуатациюТСиОборудованияТС
	               |ГДЕ
	               |	НЕ уатВводВЭксплуатациюТСиОборудованияТС.Ссылка.ПометкаУдаления
	               |	И уатВводВЭксплуатациюТСиОборудованияТС.ТС = &ТС";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаКлиенте
Процедура ВводНачальныхПоказанийСоздать(Команда)
	
	ДокументСсылка = НайтиВводНачальныхПоказаний(ТС);
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		СсылкаДокумент	 = Новый ФорматированнаяСтрока(Строка(ДокументСсылка),,,,ПолучитьНавигационнуюСсылку(ДокументСсылка));
		Содержимое		 = Новый ФорматированнаяСтрока(Нстр("ru = 'Документ был создан ранее:'") + " ");
		ПоказатьПредупреждение(,Новый ФорматированнаяСтрока(Содержимое, СсылкаДокумент));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВводНачальныхПоказаний_ДатаВвода) Тогда
		ТекстНстр = Нстр("en = 'The field ""Date entered"" is not bound'; ru = 'Поле ""Дата ввода"" не запонено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНстр);
		Возврат;
	КонецЕсли;
	
	ВводНачальныхПоказанийСоздатьСервер();
	Если СсылкаНаДокумент = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СсылкаВводНачальныхПоказаний = СсылкаНаДокумент;
	
	СсылкаДокумент	 = Новый ФорматированнаяСтрока(Строка(СсылкаНаДокумент),,,,ПолучитьНавигационнуюСсылку(СсылкаНаДокумент));
	Содержимое		 = Новый ФорматированнаяСтрока(Нстр("en = 'The document was created:'; ru = 'Создан документ:'") + " ");
	ПоказатьПредупреждение(,Новый ФорматированнаяСтрока(Содержимое, СсылкаДокумент));
	
	мТС =Новый Массив();
	мТС.Добавить(ТС);
	Оповестить("ОбновитьФорму_МестонахождениеТС", , мТС);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиВводНачальныхПоказаний(ТС)
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТС", ТС);
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	уатВводНачальныхПоказанийСпидометр.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.уатВводНачальныхПоказаний.Спидометр КАК уатВводНачальныхПоказанийСпидометр
	               |ГДЕ
	               |	НЕ уатВводНачальныхПоказанийСпидометр.Ссылка.ПометкаУдаления
	               |	И уатВводНачальныхПоказанийСпидометр.ТС = &ТС";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ВводНачальныхПоказанийСоздатьСервер()
	Попытка
		
		ДокОбъект = Документы.уатВводНачальныхПоказаний.СоздатьДокумент();
		ДокОбъект.Дата          = ВводНачальныхПоказаний_ДатаВвода;
		ДокОбъект.Организация   = ВводВЭксплуатацию_Организация;
		ТекТС           = ДокОбъект.Спидометр.Добавить();
		ТекТС.ТС        = ТС;
		Если ТС.Модель.НаличиеСпидометра Тогда
			ТекТС.ПоказанияСпидометра = ВводНачальныхПоказаний_НачальныйСпидометр;
		Иначе
			ТекТС.ПоказанияСчетчикаМЧ = ВводНачальныхПоказаний_ПоказанияСчетчикаМоточасов;
		КонецЕсли;
		Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
		ДокОбъект.Ответственный = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь,
				"ОсновнойОтветственный");
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		СсылкаНаДокумент = ДокОбъект.Ссылка;
		СсылкаДокумент	 = Новый ФорматированнаяСтрока(Строка(СсылкаНаДокумент),,,,ПолучитьНавигационнуюСсылку(СсылкаНаДокумент));
		Содержимое		 = Новый ФорматированнаяСтрока(Нстр("en = 'The document was created:'; ru = 'Создан документ:'") + " ");

		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = Новый ФорматированнаяСтрока(Содержимое, СсылкаДокумент);
		Сообщение.КлючДанных = СсылкаНаДокумент;
		Сообщение.Сообщить();

	Исключение
	КонецПопытки;
	
КонецПроцедуры

&НаКлиенте
Процедура ВводОстатковГСМСоздать(Команда)
	
	ДокументСсылка = НайтиВводОстатковГСМ(ТС);
	Если ЗначениеЗаполнено(ДокументСсылка) Тогда
		СсылкаДокумент	 = Новый ФорматированнаяСтрока(Строка(ДокументСсылка),,,,ПолучитьНавигационнуюСсылку(ДокументСсылка));
		Содержимое		 = Новый ФорматированнаяСтрока(Нстр("ru = 'Документ был создан ранее:'") + " ");
		ПоказатьПредупреждение(,Новый ФорматированнаяСтрока(Содержимое, СсылкаДокумент));
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВводВЭксплуатацию_Организация) Тогда
		ТекстНстр = Нстр("en = 'The field "" Organization "" is not bound'; ru = 'Поле ""Организация"" не запонено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНстр);
		Возврат;
	КонецЕсли;

	Если НЕ ЗначениеЗаполнено(ВводОстатковГСМ_ДатаВвода) Тогда
		ТекстНстр = Нстр("en = 'The field ""Date entered"" is not bound'; ru = 'Поле ""Дата ввода"" не запонено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНстр);
		Возврат;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(ВводОстатковГСМ_ГСМ) Тогда
		ТекстНстр = Нстр("en = 'The field ""Fuels"" is not bound'; ru = 'Поле ""ГСМ"" не запонено'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНстр);
		Возврат;
	КонецЕсли;

	ВводОстатковГСМСоздатьСервер();
	
	Если СсылкаНаДокумент = Неопределено Тогда
		Возврат;
	КонецЕсли;

	СсылкаДокумент	 = Новый ФорматированнаяСтрока(Строка(СсылкаНаДокумент),,,,ПолучитьНавигационнуюСсылку(СсылкаНаДокумент));
	Содержимое		 = Новый ФорматированнаяСтрока(Нстр("en = 'The document was created:'; ru = 'Создан документ:'") + " ");
	ПоказатьПредупреждение(,Новый ФорматированнаяСтрока(Содержимое, СсылкаДокумент));

	мТС =Новый Массив();
	мТС.Добавить(ТС);
	Оповестить("ОбновитьФорму_МестонахождениеТС", , мТС);

КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиВводОстатковГСМ(ТС)
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("ТС", ТС);
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	уатВводОстатковГСМТопливо.Ссылка КАК Ссылка
	               |ИЗ
	               |	Документ.уатВводОстатковГСМ.Топливо КАК уатВводОстатковГСМТопливо
	               |ГДЕ
	               |	НЕ уатВводОстатковГСМТопливо.Ссылка.ПометкаУдаления
	               |	И уатВводОстатковГСМТопливо.ТС = &ТС";
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Ссылка;
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	
КонецФункции

&НаСервере
Процедура ВводОстатковГСМСоздатьСервер()
	Попытка
		
		ДокОбъект = Документы.уатВводОстатковГСМ.СоздатьДокумент();
		ДокОбъект.Дата          = ВводОстатковГСМ_ДатаВвода;
		ДокОбъект.Организация   = ВводВЭксплуатацию_Организация;
		ДокОбъект.Подразделение = ВводВЭксплуатацию_Подразделение;
		ДокОбъект.Колонна       = ВводВЭксплуатацию_Колонна;
		ТекТС           = ДокОбъект.Топливо.Добавить();
		ТекТС.ТС        = ТС;
		ТекТС.ГСМ = ВводОстатковГСМ_ГСМ;
		ТекТС.Количество = ВводОстатковГСМ_Количество;
		ТекТС.Сумма = ВводОстатковГСМ_Сумма;
		ТекТС.СтавкаНДС = ВводОстатковГСМ_СтавкаНДС;
		СтавкаНДС = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеСтавкиНДС(ТекТС.СтавкаНДС);
		СуммаВключаетНДС = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ВводВЭксплуатацию_Организация,
		ПланыВидовХарактеристик.уатПраваИНастройки.СуммаВключаетНДС);
		
		ТекТС.СуммаНДС = ?(СуммаВключаетНДС, 
		ВводОстатковГСМ_Сумма - (ВводОстатковГСМ_Сумма) / ((СтавкаНДС + 100) / 100),
		ВводОстатковГСМ_Сумма * СтавкаНДС / 100);
		Пользователь = ПользователиКлиентСервер.АвторизованныйПользователь();
		ДокОбъект.Ответственный = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(Пользователь,
				"ОсновнойОтветственный");
		ДокОбъект.Записать(РежимЗаписиДокумента.Проведение);
		
		СсылкаНаДокумент = ДокОбъект.Ссылка;
		СсылкаДокумент	 = Новый ФорматированнаяСтрока(Строка(СсылкаНаДокумент),,,,ПолучитьНавигационнуюСсылку(СсылкаНаДокумент));
		Содержимое		 = Новый ФорматированнаяСтрока(Нстр("en = 'The document was created:'; ru = 'Создан документ:'") + " ");

		Сообщение = Новый СообщениеПользователю;
		Сообщение.Текст = Новый ФорматированнаяСтрока(Содержимое, СсылкаДокумент);
		Сообщение.КлючДанных = СсылкаНаДокумент;
		Сообщение.Сообщить();
		
	Исключение
	КонецПопытки;

КонецПроцедуры

#КонецОбласти