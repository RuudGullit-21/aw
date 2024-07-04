#Область СлужебныйПрограммныйИнтерфейс

Функция ИмяШага(НомерШага) Экспорт
	
	Возврат "Шаг" + НомерШага;
	
КонецФункции

Функция МаксимальноеЧислоШагов() Экспорт
	
	Возврат 9;
	
КонецФункции

// Размещает на форме элементы навигации
// 
// Параметры:
//
// Форма - ФормаКлиентскогоПриложения - Управляемая форма.
// Параметры - Структура - Структура параметров формы.
//
Процедура РазместитьНавигацию(Форма, СтруктураНавигацииПомощника, Параметры = Неопределено, Сдвиг = 0, ПостфиксЭлемента = "", ОтмечатьТекущий = Истина) Экспорт
	
	ЗаполнитьСлужебныеРеквизиты(Форма, СтруктураНавигацииПомощника, Параметры);
	Если Форма.НавигацияНомерШага = 0 Тогда
		ГруппаНавигация = Форма.Элементы.Найти("ГруппаНавигация" + ПостфиксЭлемента);
		Если ГруппаНавигация <> Неопределено Тогда
			ГруппаНавигация.Видимость = Ложь;
		КонецЕсли;
		Возврат;
	КонецЕсли;
	РазместитьКартинки(Форма, СтруктураНавигацииПомощника, Сдвиг, ПостфиксЭлемента, ОтмечатьТекущий);
	РазместитьТексты(Форма, СтруктураНавигацииПомощника, Сдвиг, ПостфиксЭлемента, ОтмечатьТекущий);
	УправлениеВидимостью(Форма, ПостфиксЭлемента);
	
КонецПроцедуры

Функция НовыйСтруктураНавигации() Экспорт
	
	Возврат Новый Структура("Структура, Описание", Новый Структура, "");
	
КонецФункции

Функция НовыйСтруктураШага() Экспорт
	
	СтруктураШага = Новый Структура;
	СтруктураШага.Вставить("ИмяПомощника", "");
	// Форма
	СтруктураШага.Вставить("ИмяФормы",                 "");
	СтруктураШага.Вставить("ОпределятьИмяФормы",       Ложь);
	СтруктураШага.Вставить("ЗаголовокФормы",           "");
	СтруктураШага.Вставить("СтруктураПараметровФормы", НовыйСтруктураПараметровФормы());
	// Служебные реквизиты
	СтруктураШага.Вставить("НомерШага",      0);
	СтруктураШага.Вставить("ТекстНавигации", "");
	СтруктураШага.Вставить("ИмяШагаДляЛК",   "");

	СтруктураШага.Вставить("ТипЭлементаРегламента",  Неопределено);
	СтруктураШага.Вставить("Доступен",      	Ложь);
	СтруктураШага.Вставить("Выполнен",      	Ложь);
	СтруктураШага.Вставить("КоличествоВерсий",  1);
	СтруктураШага.Вставить("НомерВерсии",  0);
	
	Возврат СтруктураШага;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция НовыйСтруктураПараметровФормы()
	
	СтруктураПараметровФормы = Новый Структура;
	СтруктураПараметровФормы.Вставить("НавигацияПараметрФормы", Неопределено);
	
	Возврат СтруктураПараметровФормы;
	
КонецФункции

Процедура ЗаполнитьСлужебныеРеквизиты(Форма, СтруктураНавигацииПомощника, Параметры)
	
	// Параметр навигации
	Если Параметры <> Неопределено И Параметры.Свойство("НавигацияПараметрФормы") Тогда
		Форма.НавигацияПараметрФормы = Параметры.НавигацияПараметрФормы;
	КонецЕсли;
	
	// Номер шага
	НомерШага = 0;
	Для Каждого Шаг Из СтруктураНавигацииПомощника Цикл
		СтруктураШага = Шаг.Значение;
		Если СтруктураШага.СтруктураПараметровФормы.НавигацияПараметрФормы = Форма.НавигацияПараметрФормы Тогда
			НомерШага = СтруктураШага.НомерШага;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	
	Форма.НавигацияНомерШага = НомерШага;
	
	Если НомерШага = 0 Тогда
		Возврат;
	КонецЕсли;
	
	// Заголовок
	СтруктураШага = СтруктураНавигацииПомощника[ИмяШага(НомерШага)];
	Если Не ПустаяСтрока(СтруктураШага.ЗаголовокФормы) Тогда
		Форма.Заголовок = СтруктураШага.ЗаголовокФормы;
	КонецЕсли;
	
КонецПроцедуры

Процедура РазместитьКартинки(Форма, СтруктураНавигацииПомощника, Сдвиг = 0, ПостфиксЭлемента = "", ОтмечатьТекущий = Ложь)
	
	НомерШагаФормы = Форма.НавигацияНомерШага;
	
	КартинкаОтступ = ?(НомерШагаФормы = 1 И ОтмечатьТекущий = Истина,
		БиблиотекаКартинок.НавигацияОтступТекущийШагБЭД,
		БиблиотекаКартинок.НавигацияОтступВыполненныйШагБЭД);
	
	СтруктураКартинокНавигации = СтруктураКартинокНавигации();
	
	МассивФорматированныхСтрок = Новый Массив;
	МассивФорматированныхСтрок.Добавить(КартинкаОтступ);
	
	Если Сдвиг > 0 Тогда
		Для К = 1 По Сдвиг Цикл
			МассивФорматированныхСтрок.Добавить(БиблиотекаКартинок.НавигацияОтступСдвигаШагаБЭД);	
		КонецЦикла;
	КонецЕсли;
	
	МинШаг = Неопределено;
	Для Каждого КиЗ Из СтруктураНавигацииПомощника Цикл
		НомерШагаКиЗ = Число(СтрЗаменить(КиЗ.Ключ, "Шаг", ""));
		Если МинШаг = Неопределено Или МинШаг > НомерШагаКиЗ Тогда
			МинШаг = НомерШагаКиЗ;
		КонецЕсли;	
	КонецЦикла;
	СдвигаНомераШага = МинШаг - 1;
	
	Если Сдвиг > 0 Тогда
		СтруктураПервогоШага = СтруктураНавигацииПомощника[ИмяШага(МинШаг)];
		МассивФорматированныхСтрок.Добавить(?(СтруктураПервогоШага.Выполнен, 
												БиблиотекаКартинок.НавигацияКриваяЛинияШагВыполненныйБЭД, 
												БиблиотекаКартинок.НавигацияКриваяЛинияШагНеВыполненныйБЭД));
	КонецЕсли;
	
	Для НомерШага = 1 По СтруктураНавигацииПомощника.Количество() Цикл
		
		НомерШагаСоСдвигом = НомерШага + СдвигаНомераШага;
		
		СтруктураШага = СтруктураНавигацииПомощника[ИмяШага(НомерШагаСоСдвигом)];
		
		ВыводитьЛинию = (НомерШага <> 1);
		
		// Шаги
		ИдентификаторШага = "";
		Если ОтмечатьТекущий = Истина И НомерШагаСоСдвигом = НомерШагаФормы Тогда
			ИдентификаторШага = "Текущий";
		КонецЕсли;
		ИдентификаторШага = ИдентификаторШага + ?(СтруктураШага.Выполнен, "Выполненный", "НеВыполненный");
		ИмяКартинкиШага = СтрШаблон("Шаг%1", ИдентификаторШага);
		
		// Линия
		ЦветЛинии   = ?(СтруктураШага.Выполнен, "Выполненный", "НеВыполненный");
		РазмерЛинии = ?(НомерШагаСоСдвигом = НомерШагаФормы ИЛИ НомерШагаСоСдвигом = НомерШагаФормы + 1, "Текущий", "");
		ИмяЛинии    = СтрШаблон("ЛинияШаг%1%2", ЦветЛинии, РазмерЛинии);
		
		// Ссылка
		ИмяСсылки = ?(СтруктураШага.Выполнен, ИмяШага(НомерШагаСоСдвигом), "");
		
		Если ВыводитьЛинию Тогда
			МассивФорматированныхСтрок.Добавить(СтруктураКартинокНавигации[ИмяЛинии]);
		КонецЕсли;
		МассивФорматированныхСтрок.Добавить(Новый ФорматированнаяСтрока(СтруктураКартинокНавигации[ИмяКартинкиШага],,,,ИмяСсылки));
		
	КонецЦикла;
	
	ЭлементНавигацииКартинка = Форма.Элементы.Найти("НавигацияКартинка" + ПостфиксЭлемента);
	
	ЭлементНавигацииКартинка.Заголовок = Новый ФорматированнаяСтрока(МассивФорматированныхСтрок);
	
КонецПроцедуры

Процедура РазместитьТексты(Форма, СтруктураНавигацииПомощника, Сдвиг = 0, ПостфиксЭлемента = "", ОтмечатьТекущий = Истина)
	
	ТекущийНомерШага = Форма.НавигацияНомерШага;
	КоличествоШагов  = СтруктураНавигацииПомощника.Количество();
	
	МинШаг = Неопределено;
	Для Каждого КиЗ Из СтруктураНавигацииПомощника Цикл
		НомерШагаКиЗ = Число(СтрЗаменить(КиЗ.Ключ, "Шаг", ""));
		Если МинШаг = Неопределено Или МинШаг > НомерШагаКиЗ Тогда
			МинШаг = НомерШагаКиЗ;
		КонецЕсли;	
	КонецЦикла;
	СдвигаНомераШага = МинШаг - 1;
	
	Для НомерШага = 1 По КоличествоШагов Цикл
		
		НомерШагаСоСдвигом = НомерШага + СдвигаНомераШага;
		
		СтруктураШага = СтруктураНавигацииПомощника[ИмяШага(НомерШагаСоСдвигом)];
		
		НужнаГиперссылка = Ложь;
		Если СтруктураШага.Доступен = Истина
			И (НомерШагаСоСдвигом <> ТекущийНомерШага ИЛИ ОтмечатьТекущий = Ложь) Тогда
				НужнаГиперссылка = Истина;
		КонецЕсли;
		
		ИмяСсылки   = ?(НужнаГиперссылка, ИмяШага(НомерШагаСоСдвигом), "");
		ШрифтТекста = Неопределено; //?(ОтмечатьТекущий = Истина И НомерШагаСоСдвигом = ТекущийНомерШага, ШрифтыСтиля.Шрифт12EDI, Неопределено);
		Если СтруктураШага.Выполнен = Истина Тогда
			ЦветТекста = ?(ОтмечатьТекущий = Истина И НомерШагаСоСдвигом = ТекущийНомерШага,
				ЦветаСтиля.ЦветТекстаПоля, ЦветаСтиля.ЦветТекстаВыполненныйШагЭПД);
		Иначе
			ЦветТекста  = ?(ОтмечатьТекущий = Истина И НомерШагаСоСдвигом = ТекущийНомерШага,
				ЦветаСтиля.ЦветТекстаПоля, ЦветаСтиля.ЦветТекстаНеВыполненныйШагЭПД);
		КонецЕсли;
		
		ЭлементФормы = Форма.Элементы[ИмяШага(НомерШагаСоСдвигом)];
		
		МассивФорматированныхСтрок = Новый Массив;
		МассивФорматированныхСтрок.Добавить(Новый ФорматированнаяСтрока(СтруктураШага.ТекстНавигации, ШрифтТекста, ЦветТекста, , ИмяСсылки));
		
		Если СтруктураШага.КоличествоВерсий > 1 Тогда
			МассивФорматированныхСтрок.Добавить(Символы.ПС);
			Если ОтмечатьТекущий = Истина И НомерШагаСоСдвигом = ТекущийНомерШага Тогда
				Если СтруктураШага.НомерВерсии = 0 Тогда
					МассивФорматированныхСтрок.Добавить(БиблиотекаКартинок.НавигацияСтрелкаВлевоНеАктивнаяБЭД);	
				Иначе
					МассивФорматированныхСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.НавигацияСтрелкаВлевоАктивнаяБЭД,,,,"Влево"));
				КонецЕсли;
				МассивФорматированныхСтрок.Добавить(Новый ФорматированнаяСтрока(
														" " + Строка(СтруктураШага.НомерВерсии + 1) + " из " + Строка(СтруктураШага.КоличествоВерсий) + " ", 
														ШрифтТекста, ЦветТекста));	
				Если СтруктураШага.НомерВерсии + 1 = СтруктураШага.КоличествоВерсий Тогда
					МассивФорматированныхСтрок.Добавить(БиблиотекаКартинок.НавигацияСтрелкаВправоНеАктивнаяБЭД);
				Иначе
					МассивФорматированныхСтрок.Добавить(Новый ФорматированнаяСтрока(БиблиотекаКартинок.НавигацияСтрелкаВправоАктивнаяБЭД,,,,"Вправо"));
				КонецЕсли;
			Иначе
				МассивФорматированныхСтрок.Добавить(Новый ФорматированнаяСтрока("(" + Строка(СтруктураШага.КоличествоВерсий) + ")", ШрифтТекста, ЦветТекста));
			КонецЕсли;
			ЭлементФормы.Высота = 3;
		КонецЕсли;
			
		ЭлементФормы.Заголовок = Новый ФорматированнаяСтрока(МассивФорматированныхСтрок);
		ЭлементФормы.Видимость = Истина;
		
	КонецЦикла;
	
	// Сдвиг
	Если Сдвиг > 0 Тогда
		ЭлементФормы = Форма.Элементы.Найти("НавигацияСдвигТекстовШагов" + ПостфиксЭлемента);
		Если ЭлементФормы <> Неопределено Тогда
			МассивФорматированныхСтрок = Новый Массив;
			МассивФорматированныхСтрок.Добавить(БиблиотекаКартинок.НавигацияОтступНаШиринуКривойШагаБЭД);
			Для К = 1 По Сдвиг Цикл
				МассивФорматированныхСтрок.Добавить(БиблиотекаКартинок.НавигацияОтступСдвигаШагаБЭД);	
			КонецЦикла;
			ЭлементФормы.Заголовок = Новый ФорматированнаяСтрока(МассивФорматированныхСтрок);
		КонецЕсли;
	КонецЕсли;
	
	//Очистка неиспользуемых шагов навигации
	МаксимальноеЧислоШагов = МаксимальноеЧислоШагов();
	Если КоличествоШагов < МаксимальноеЧислоШагов Тогда
		Для НомерШага = КоличествоШагов + 1 По МаксимальноеЧислоШагов Цикл
			
			НомерШагаСоСдвигом = НомерШага + СдвигаНомераШага;
			
			ЭлементФормы = Форма.Элементы.Найти(ИмяШага(НомерШагаСоСдвигом));
			Если ЭлементФормы <> Неопределено Тогда
				ЭлементФормы.Видимость = Ложь;
			КонецЕсли;
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

Функция СтруктураКартинокНавигации()

	СтруктураКартинокНавигации = Новый Структура;
	СтруктураКартинокНавигации.Вставить("ЛинияШагВыполненный",          БиблиотекаКартинок.НавигацияЛинияШагВыполненныйБЭД);
	СтруктураКартинокНавигации.Вставить("ЛинияШагНеВыполненный",        БиблиотекаКартинок.НавигацияЛинияШагНеВыполненныйБЭД);
	СтруктураКартинокНавигации.Вставить("ЛинияШагВыполненныйТекущий",   БиблиотекаКартинок.НавигацияЛинияШагВыполненныйТекущийБЭД);
	СтруктураКартинокНавигации.Вставить("ЛинияШагНеВыполненныйТекущий", БиблиотекаКартинок.НавигацияЛинияШагНеВыполненныйТекущийБЭД);
	СтруктураКартинокНавигации.Вставить("ШагВыполненный",               БиблиотекаКартинок.НавигацияШагВыполненныйБЭД);
	СтруктураКартинокНавигации.Вставить("ШагТекущийВыполненный",        БиблиотекаКартинок.НавигацияШагТекущийВыполненныйБЭД);
	СтруктураКартинокНавигации.Вставить("ШагТекущийНеВыполненный",      БиблиотекаКартинок.НавигацияШагТекущийНеВыполненныйБЭД);
	СтруктураКартинокНавигации.Вставить("ШагНеВыполненный",             БиблиотекаКартинок.НавигацияШагНеВыполненныйБЭД);
	Возврат СтруктураКартинокНавигации;

КонецФункции

Процедура УправлениеВидимостью(Форма, ПостфиксЭлемента = "")
	
	ГруппаНавигация = Форма.Элементы.Найти("ГруппаНавигация" + ПостфиксЭлемента);
	Если ГруппаНавигация <> Неопределено Тогда
		ГруппаНавигация.Видимость = Истина;
	КонецЕсли;
	
	КомандаНазад = Форма.Элементы.Найти("КомандаНазад");
	Если Форма.НавигацияНомерШага = 1 И КомандаНазад <> Неопределено Тогда
		КомандаНазад.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти