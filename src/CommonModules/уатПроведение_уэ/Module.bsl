////////////////////////////////////////////////////////////////////////////////
// Модуль содержит процедуры и функции обеспечения проведения
// Вариант поставки КОРП
////////////////////////////////////////////////////////////////////////////////


#Область СлужебныйПрограммныйИнтерфейс

#Область ФормированиеДвиженийРегистров

// Выполняет движения регистра оборотов уатРекламации_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьРекламации(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаРекламации;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияСостояние = Движения.уатРекламации_уэ;
	ДвиженияСостояние.Записывать = Истина;
	ДвиженияСостояние.Загрузить(ТаблицаДвижений);

КонецПроцедуры

// Выполняет движения регистра остатков уатНевыставленныеРекламации_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьНевыставленныеРекламации(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаНевыставленныеРекламации;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияСостояние = Движения.уатНевыставленныеРекламации_уэ;
	ДвиженияСостояние.Записывать = Истина;
	ДвиженияСостояние.Загрузить(ТаблицаДвижений);

КонецПроцедуры

// Выполняет движения регистра сведений уатСтатусыГрузов_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьСтатусыГрузов(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСтатусыГрузов;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияСостояние = Движения.уатСтатусыГрузов_уэ;
	ДвиженияСостояние.Записывать = Истина;
	ДвиженияСостояние.Загрузить(ТаблицаДвижений);
	
КонецПроцедуры

// Выполняет движения регистра накопления уатГрузыКПеревозке_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьГрузыКПеревозке(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаГрузовКПеревозке;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияЗаявки = Движения.уатГрузыКПеревозке_уэ;
	ДвиженияЗаявки.Записывать = Истина;
	ДвиженияЗаявки.Загрузить(ТаблицаДвижений);

КонецПроцедуры

// Выполняет движения регистра сведений уатТарифыСебестоимости_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьТарифыСебестоимости(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаТарифы;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияЗаявки = Движения.уатТарифыСебестоимости_уэ;
	ДвиженияЗаявки.Записывать = Истина;
	ДвиженияЗаявки.Загрузить(ТаблицаДвижений);

КонецПроцедуры

// Выполняет движения регистра накопления уатОстаткиГрузовВКонтейнерах_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьОстаткиГрузовВКонтейнерах(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОстаткиГрузовВКонтейнерах;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияСостояние = Движения.уатОстаткиГрузовВКонтейнерах_уэ;
	ДвиженияСостояние.Записывать = Истина;
	ДвиженияСостояние.Загрузить(ТаблицаДвижений);
	
КонецПроцедуры

// Выполняет движения регистра накопления уатОстаткиГрузовНаСкладеКомплектации_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьОстаткиГрузовНаСкладеКомплектации(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОстаткиГрузов;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияСостояние = Движения.уатОстаткиГрузовНаСкладеКомплектации_уэ;
	ДвиженияСостояние.Записывать = Истина;
	ДвиженияСостояние.Загрузить(ТаблицаДвижений);
	
КонецПроцедуры

// Выполняет движения регистра накопления уатПлановыеУслуги_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьПлановыеУслуги(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаПлановыеУслуги;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияЗаявки = Движения.уатПлановыеУслуги_уэ;
	ДвиженияЗаявки.Записывать = Истина;
	ДвиженияЗаявки.Загрузить(ТаблицаДвижений);

КонецПроцедуры

// Выполняет движения регистра накопления уатСкладскоеХранениеГрузов_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьСкладскоеХранениеГрузов(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаСкладскоеХранениеГрузов;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияЗаявки = Движения.уатСкладскоеХранениеГрузов_уэ;
	ДвиженияЗаявки.Записывать = Истина;
	ДвиженияЗаявки.Загрузить(ТаблицаДвижений);

КонецПроцедуры

// Выполняет движения регистра накопления уатСкладскоеХранениеГрузов_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьГрузыВРейсах(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаГрузыВРейсах;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияЗаявки = Движения.уатГрузыВРейсах_уэ;
	ДвиженияЗаявки.Записывать = Истина;
	ДвиженияЗаявки.Загрузить(ТаблицаДвижений);
	
КонецПроцедуры

// Выполняет движения регистра сведений уатВыработкаПоМаршрутнымЛистам_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьВыработкуПоМаршрутнымЛистам(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаВыработкаПоМаршрутнымЛистам;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияСостояние = Движения.уатВыработкаПоМаршрутнымЛистам_уэ;
	ДвиженияСостояние.Записывать = Истина;
	ДвиженияСостояние.Загрузить(ТаблицаДвижений);
	
КонецПроцедуры

// Выполняет движения регистра сведений уатОбъемыПеревозок_уэ
//
// Параметры:
//  ДополнительныеСвойства	 - 	 - 
//  Движения				 - 	 - 
//  Отказ					 - 	 - 
//
Процедура ОтразитьОбъемыПеревозок(ДополнительныеСвойства, Движения, Отказ) Экспорт
	
	ТаблицаДвижений = ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаОбъемыПеревозок;
	
	Если Отказ ИЛИ ТаблицаДвижений.Количество() = 0 Тогда
		Возврат;
	КонецЕсли;
	
	ДвиженияСостояние = Движения.уатОбъемыПеревозок_уэ;
	ДвиженияСостояние.Записывать = Истина;
	ДвиженияСостояние.Загрузить(ТаблицаДвижений);
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
